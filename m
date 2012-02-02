Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab2BBJ4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:56:34 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:35256 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab2BBJ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:56:32 -0500
Date: Thu, 2 Feb 2012 12:56:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: pawel.moll@arm.com
Cc: linux-kernel@vger.kernel.org
Subject: re: params: <level>_initcall-like kernel parameters
Message-ID: <20120202095612.GA30632@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020209.4F2A5DC3.001C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pawel Moll,

The patch b41c2e271944: "params: <level>_initcall-like kernel 
parameters" from Dec 12, 2011, leads to the following warning:
init/main.c:749 do_initcall_level()
	 error: buffer overflow 'initcall_level_names' 7 <= 7

   743  static void __init do_initcall_level(int level)
   744  {
   745          extern const struct kernel_param __start___param[], __stop___param[];
   746          initcall_t *fn;
   747  
   748          strcpy(static_command_line, saved_command_line);
   749          parse_args(initcall_level_names[level],
                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^
initcall_level_names[] has 7 elements so initcall_level_names[7] is past
the end of the array.

   750                     static_command_line, __start___param,
   751                     __stop___param - __start___param,
   752                     level, level,
   753                     ignore_unknown_bootoption);
   754  
   755          for (fn = initcall_levels[level]; fn < initcall_levels[level+1]; fn++)
   756                  do_one_initcall(*fn);
   757  }
   758  
   759  static void __init do_initcalls(void)
   760  {
   761          int level;
   762  
   763          for (level = 0; level < ARRAY_SIZE(initcall_levels) - 1; level++)
                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
initcall_levels[] has 9 elements so level is 0-7 here.

   764                  do_initcall_level(level);
   765  }

regards,
dan carpenter

