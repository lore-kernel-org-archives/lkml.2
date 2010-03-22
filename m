Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab0CVLcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:32:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37435 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab0CVLca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AiA1Yj1wTsnkaiLDfa2SZC0WJSRJLB2CYJfG2wOXWUjtqEXPRtd98+Hb7EZV/G16wy
         9Sn2LtCQcnjujkMlENMZ6Uj6gqrHhHuNmG+nyO5nOswYM7g+uTg17pFju+zo/xcFq01y
         vYFBaXIwxQD6QszDnQizaDYNJnCDEpSwlFe6o=
MIME-Version: 1.0
In-Reply-To: <p06240805c7cc98bdf217@192.168.9.6>
References: <c384c5ea1003211403t494bd794hece06d8b8cfcb54@mail.gmail.com>
	 <p06240805c7cc98bdf217@192.168.9.6>
Date: Mon, 22 Mar 2010 12:32:25 +0100
Message-ID: <c384c5ea1003220432i78883b0fof64f3ffa666a0776@mail.gmail.com>
Subject: Re: CrystalHD driver safe on big endian systems?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: "Scott D. Davilla" <davilla@4pi.com>
Cc: jarod@wilsonet.com, "Naren (Narendra) Sankar" <nsankar@broadcom.com>,
       "hancockrwd@gmail.com" <hancockrwd@gmail.com>,
       "jarod@redhat.com" <jarod@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "abraham.manu@gmail.com" <abraham.manu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Scott and others,

On Mon, Mar 22, 2010 at 4:53 AM, Scott D. Davilla <davilla@4pi.com> wrote:
>
> <..> From what I've seen in code, it looks definite little endian based and would need
> a look over regarding byte swap.
>
What parts of the code assumes little endian from what you've seen?

Now, byte swap endianess is one thing, C bitfields in combination with
it, another. I have given it a first shot here (mailer unsuitable for
sending patches), still failed on PowerPC:
http://www.sidebranch.com/crystalhd/

May I suggest we instrument all register access functions with a
printk() of the register being written? Then I can compare little
endian access patterns with big endian, to be sure we get the
bitfields, code assumptions and byte swap correctly.

Regards,
-- 
Leon
