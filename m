Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937558Ab0CPIS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 04:18:59 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56401 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937533Ab0CPIS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 04:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=H2FGfyXk7xT+kOCOG8+jbOnrvn7kDwQt3Onld7PN+F5A5Dco3BQxevAgKdu3vnsevy
         90cUbCRO7z6kofTcigEvMSPXz+mmSZ7V7PmUPZ1VHG5RekMwFYwXtCdgpVnUneWDRQBQ
         lin/8ND0QOGm2M+a9PROY9V3HmNkRKIYvInNQ=
Message-ID: <4B9F3EEC.7050104@gmail.com>
Date: Tue, 16 Mar 2010 10:18:52 +0200
From: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: fix callgraphs of 32-bit processes on 64-bit kernels.
References: <1268667260-5505-1-git-send-email-edwintorok@gmail.com> <4B9E5EFF.1080308@gmail.com>
In-Reply-To: <4B9E5EFF.1080308@gmail.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=5379965D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 06:23 PM, Török Edwin wrote:
> On 03/15/2010 05:34 PM, Török Edwin wrote:
>>
>> It would be good if perf knew how to lookup symbols in kernel modules!
> 
> BTW perf report -m -k /home/edwin/builds/linux-2.6/vmlinux doesn't show
> the symbols either.

I always forget that, unlike every other program, perf doesn't install
by default to /usr/local!
So I was running the wrong version of perf (from an older kernel), since
perf was installed to $HOME/bin (which of course isn't in sudo's path).

Sorry for the confusion, the 2.6.33 perf DOES know how to lookup the
symbols:
    9.92%  glxgears  [radeon]                           [k]
r600_packet3_check
            |
            --- r600_packet3_check
               |
               |--96.80%-- r600_cs_parse
               |          radeon_cs_ioctl
               |          drm_ioctl
               |          radeon_kms_compat_ioctl
               |          compat_sys_ioctl
               |          sysenter_dispatch
               |          0xf7759430
               |          drmCommandWriteRead
               |          cs_gem_emit
               |          radeon_cs_emit
               |          rcommonFlushCmdBufLocked
               |          rcommonFlushCmdBuf
               |          radeonFlush
               |          _mesa_flush
               |          _mesa_Flush
               |          0xf76ee270
               |          0x804a6d5
               |          __libc_start_main
               |          0x8049111
[...]

Best regards,
--Edwin
