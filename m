Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2JOQVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:21:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34807 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2JOQVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:21:22 -0400
Message-ID: <507C37FC.9060604@lwfinger.net>
Date: Mon, 15 Oct 2012 11:21:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Problem with  KERNEL_VERSION macros in 3.7-rc1?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VirtualBox kernel modules need to be modified to account for the removal of 
VM_RESERVED in version 3.7-rc1. When I used the normal test of 
LINUX_VERSION_CODE against KERNEL_VERSION(3, 7, 0), the fix did not work. To 
test why, I added the following code snippet to a module:

#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 7, 0)
#warning "Compiling 3.7.0"
#else
#warning "Compiling older kernel"
#endif

When compiling this code, I get 'warning: #warning "Compiling older kernel" 
[-Wcpp]' on the console. The command 'uname -r' echoes "3.7.0-rc1", and 'git 
describe' returns "v3.7-rc1".

My workaround is to define VM_RESERVED if it is not defined.

Thanks,

Larry




