Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1CABwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 20:52:30 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63935 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1CABw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 20:52:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j4P73pu2PhuXYYzDESkGKIy814jQfWLJSL0/qlvIehF+lTwbbKrSobbjXmqK7wpY1L
         kPDX/hF7XPlibwSau/PYBmMtI00bCd1Rh5c1p/iIDuQY8+EbDlXqlLgxxNgNdJe6AN0h
         BaeVFF0z5BR3Xak6TX7qsKLv+h+5PcsKR/L60=
MIME-Version: 1.0
In-Reply-To: <20110228162554.GE25998@cr0.redhat.com>
References: <AANLkTimp0bywKCoqdc8=dZdGmRoOQZoySvjFRLsrk0np@mail.gmail.com>
	<AANLkTimxxTMU3=4ry-_zbY6v1xiDi+hW9y1RegTr8vLK@mail.gmail.com>
	<20110228162554.GE25998@cr0.redhat.com>
Date: Tue, 1 Mar 2011 09:52:28 +0800
Message-ID: <AANLkTinLHji_PKZ5pRHVHdsVdiX0N3=NJxDHsORNS4T5@mail.gmail.com>
Subject: Re: [2.6.38-rc6] build:mkpiggy fixlet...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 March 2011 00:25, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Feb 23, 2011 at 09:33:59AM +0800, Daniel J Blueman wrote:
>>Ensure build doesn't silently continue despite read failure,
>>addressing a warning due to the unchecked call.
>>
>>Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
>>
>>diff --git a/arch/x86/boot/compressed/mkpiggy.c
>>b/arch/x86/boot/compressed/mkpiggy.c
>>index 646aa78..845a1f8 100644
>>--- a/arch/x86/boot/compressed/mkpiggy.c
>>+++ b/arch/x86/boot/compressed/mkpiggy.c
>>@@ -62,7 +62,12 @@ int main(int argc, char *argv[])
>>       if (fseek(f, -4L, SEEK_END)) {
>>               perror(argv[1]);
>>       }
>>-      fread(&olen, sizeof olen, 1, f);
>>+
>>+      if (fread(&olen, sizeof(olen), 1, f) != 1) {
>>+              perror(argv[1]);
>>+              return 1;
>
> You need to close the file here...

I could close the file here to be polite, but since the program is
exiting, the OS will close the file.

I added the error path in a way consistent with the following error
path - perhaps better than a more intrusive patch to handle everything
gracefully; it just fixes the bug (ie silent failure) and isn't a
cleanup.

>>+      }
>>+
>>       ilen = ftell(f);
>>       olen = getle32(&olen);
>>       fclose(f);
-- 
Daniel J Blueman
