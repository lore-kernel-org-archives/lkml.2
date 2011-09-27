Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab1I0Njc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:39:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53459 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1I0Njb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:39:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH V4] mtd: Add DiskOnChip G3 support
Date: Tue, 27 Sep 2011 15:39:21 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: dedekind1@gmail.com, dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1316633266-21312-1-git-send-email-robert.jarzmik@free.fr> <1316702729.4849.114.camel@sauron> <87mxdwiicc.fsf@free.fr>
In-Reply-To: <87mxdwiicc.fsf@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271539.21533.arnd@arndb.de>
X-Provags-ID: V02:K0:mMRMYDqZ2cgdMge11/n8ThMvhgQ40ucQidS1DMVi5vG
 eGbJIWNybcuTSS9eXSUA4Vqik/fQm3AE5fk9a/DAc0oouoyQaP
 JfZSt9kHC7QaZmMfS7QgszYAbtNkeGuIY/fUH+As6uTrqV7zFE
 48xNYDIPzbi9pwLuHxQJ6kYajuOKJGB1V5fdTaHFimWqq0rdWw
 f5MVLPvcJTodomDFl65zCGXcgbn6vnfavjV+Y3XyMo1XQdDocG
 zKTgXIDofuXiOpCyzAR1xd9coNIzqJnDmjusDTJEVAyaigLLWl
 jAsZ2TVuB0XFhj1+LjBis9Md9A+39MCIPWp52/4pkAx9ovnRbb
 i25sRCmQIEGwuIxPJuxU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 September 2011, Robert Jarzmik wrote:
> >> +#define doc_flashSequence(seq)                                              \
> >> +do {                                                                        \
> >> +    doc_dbg("doc_flashSequence: %02x " #seq "\n", DoC_Seq_##seq);   \
> >> +    doc_writeb(DoC_Seq_##seq, DoC_FlashSequence);                   \
> >> +} while (0)
> >> +
> ...zip...
> >
> > Could you please turn these macros into 'static inline' function - this
> > is one of the modern patterns of kernel programming - we try to use
> > functions for better type checking.
>
> No sorry, that I cannot. If you look closely, the ##seq is not something you can
> convert with an inline function, neither the #seq.

Better not obfuscate the code like that then ;-)

Really, passing the entire register name into an inline function is much
preferred over string concatenation, because it lets you grep for where
certain definitions are used. You can also convert them to ALL_CAPS
identifiers instead of cAmeLCAsE.

Finally, don't use the __raw_readb() style functions but instead use
the regular readb() style, which is the correct one to use in device
drivers.

	Arnd
