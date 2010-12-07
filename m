Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0LGJFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:05:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63950 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab0LGJFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:05:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 01/45] kstrtox: converting strings to integers done (hopefully) right
Date: Tue, 7 Dec 2010 10:04:58 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: Jesper Juhl <jj@chaosbits.net>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com> <alpine.LNX.2.00.1012060120590.16078@swampdragon.chaosbits.net> <AANLkTinbq+NPHBQ=zqVNjUDL+G3fKdC6S9gYB5e4isNR@mail.gmail.com>
In-Reply-To: <AANLkTinbq+NPHBQ=zqVNjUDL+G3fKdC6S9gYB5e4isNR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012071004.58311.arnd@arndb.de>
X-Provags-ID: V02:K0:xaKTXopd9/UG65xFSVDiEA2Jm2ReYh5Rd9tOUF+ggIh
 8Mix5dyKVBL1BkNYz6XW2bVOZ0O0SD63808PPpvB2RphKAH8cZ
 IjbdmY9OPMvz/CnTthMxI8zEqQcTh6SXgyhBSAWFbYx2in1QyT
 N8GFjx3zFQjGR6eCmdGMCUPrLlVi93twguXKm/+BfzRhDwAJSy
 lJFOX71iOnOSDh8agLqaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 December 2010 16:16:36 Alexey Dobriyan wrote:
> > <snip>
> >> +/* Internal, do not use. */
> >> +int _kstrtol(const char *s, unsigned int base, long *res)
> >> +{
> >> +     long long tmp;
> >> +     int rv;
> >> +
> >> +     rv = kstrtoll(s, base, &tmp);
> >> +     if (rv < 0)
> >> +             return rv;
> >> +     if (tmp != (long long)(long)tmp)
> >> +             return -EINVAL;
> >> +     *res = tmp;
> >> +     return 0;
> >> +}
> >> +EXPORT_SYMBOL(_kstrtol);
> >
> > Ok, probably I'm just being dense, but the "_" prefix tells me I probably
> > shouldn't use this function. The comment clearly tells me I shouldn't use
> > this function.
> > So, why is this exported? And if it is not/should not be exported, then
> > why is it not static?
> > (goes for other functions in this patch as well).
> 
> It is used by kstrtol() if "long" and "long long" aren't the same type.
> I can't ifdef it because gcc doesn't allow "#if sizeof(long long) == ".
> "Do not use" hints "use kstrtol()".

Can't you use #ifdef CONFIG_64BIT to see if long is 64 bit wide?

	Arnd
