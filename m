Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab1IBCEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 22:04:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52188 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040Ab1IBCEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 22:04:47 -0400
Message-ID: <4E6039BA.1010805@gmail.com>
Date: Thu, 01 Sep 2011 19:04:42 -0700
From: Nicholas Miell <nmiell@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/ directory
 v6
References: <20110831075814.003575573@openvz.org> <20110831080229.100652529@openvz.org> <4E603758.6050003@gmail.com> <20110902015807.GG2752@htj.dyndns.org>
In-Reply-To: <20110902015807.GG2752@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 06:58 PM, Tejun Heo wrote:
> On Thu, Sep 01, 2011 at 06:54:32PM -0700, Nicholas Miell wrote:
>> This doesn't seem to fully export all the information passed to mmap(2)
>> -- it encompasses the addr, size, fd and (assuming the generated
>> symlink's permissions are accurate) prot parameters, but does nothing to
>> export the flags or offset parameters.
> 
> It looks like,
> 
> /proc/*/fd : fdinfo ~= map_files : maps
> 

So are the filenames in /proc/$PID/map_files/ guaranteed to be identical
to the first field (first two fields? the part before the first space)
in /proc/$PID/maps?

When I open a file in /proc/$PID/map_files/, is offset 0 the start of
the file on disk or is it the first byte of the mapping?
