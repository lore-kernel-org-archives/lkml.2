Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab1B1Q0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:26:12 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35727 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1B1Q0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:26:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cYaCTkukEBZ64O304wEncv+ZLibDdeUWq196upagMKLy509ah/hGN9Kd6ZHlnFd0ps
         X/F3/ByyWxVlD5UHWaysl6P68tBHFSG6C2loFcC7lR7x+Jm7vsRx6DFEi3btXFkbyUik
         fJNx2Lm7GWyh5J6Gulw/xqw7qNs0hA2X9NEfI=
Date: Tue, 1 Mar 2011 00:25:54 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [2.6.38-rc6] build:mkpiggy fixlet...
Message-ID: <20110228162554.GE25998@cr0.redhat.com>
References: <AANLkTimp0bywKCoqdc8=dZdGmRoOQZoySvjFRLsrk0np@mail.gmail.com>
 <AANLkTimxxTMU3=4ry-_zbY6v1xiDi+hW9y1RegTr8vLK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimxxTMU3=4ry-_zbY6v1xiDi+hW9y1RegTr8vLK@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 09:33:59AM +0800, Daniel J Blueman wrote:
>Ensure build doesn't silently continue despite read failure,
>addressing a warning due to the unchecked call.
>
>Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
>
>diff --git a/arch/x86/boot/compressed/mkpiggy.c
>b/arch/x86/boot/compressed/mkpiggy.c
>index 646aa78..845a1f8 100644
>--- a/arch/x86/boot/compressed/mkpiggy.c
>+++ b/arch/x86/boot/compressed/mkpiggy.c
>@@ -62,7 +62,12 @@ int main(int argc, char *argv[])
> 	if (fseek(f, -4L, SEEK_END)) {
> 		perror(argv[1]);
> 	}
>-	fread(&olen, sizeof olen, 1, f);
>+
>+	if (fread(&olen, sizeof(olen), 1, f) != 1) {
>+		perror(argv[1]);
>+		return 1;


You need to close the file here...


>+	}
>+		
> 	ilen = ftell(f);
> 	olen = getle32(&olen);
> 	fclose(f);

Thanks.
