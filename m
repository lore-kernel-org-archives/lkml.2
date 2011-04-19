Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab1DSBO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:14:59 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59787 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab1DSBO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:14:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q00sm4LGS3vy/HqRodamKkj7uJy69bPei7/pmRi2+6hWfhc/HDKQqRhqWzL08UzDOl
         zJ+oW/AdS/PU7viZAiGPxStSBm/fbZnieq6pSTMb2ty0X3LK0swAEtThdMcycs8mBp7y
         crvofSMFO5Fb6Ba689FpxD/fx/2/NJPEdWK/Q=
MIME-Version: 1.0
In-Reply-To: <20110418220232.GA15967@hallyn.com>
References: <BANLkTikTxCFHs2xb4b5QFQp3SJAEjgyRJg@mail.gmail.com>
	<20110417180722.GA21112@hallyn.com>
	<BANLkTinumLPEsstxP9px9=K23SUR9e2aRw@mail.gmail.com>
	<20110418082838.GA30088@hallyn.com>
	<BANLkTi=kxpFkQ86ZGd2_q+XFRm-nVWzw4g@mail.gmail.com>
	<20110418220232.GA15967@hallyn.com>
Date: Tue, 19 Apr 2011 10:14:57 +0900
Message-ID: <BANLkTikJqgwGixtgXKOY-2e=1sAQYUtbcQ@mail.gmail.com>
Subject: Re: Linux capabilities shouldn't be lost during setuid to non-root
 from root or to another non-root uid from a non-root uid.
From: crocket <crockabiscuit@gmail.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there an existing utility that sets SECBIT_NO_SETUID_FIXUP?
Or is there a way to set it without writing a C wrapper program?

On Tue, Apr 19, 2011 at 7:02 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting crocket (crockabiscuit@gmail.com):
>> I have several questions.
>>
>> 1) How do I set SECBIT_NO_SETUID_FIXUP?
>
> prctl(PR_SET_SECUREBITS, SECBIT_NO_SETUID_FIXUP | SECBIT_NO_SETUID_FIXUP_LOCKED)
>
> see capabilities(7) for details.
>
>> 2) Is there any reason to unset SECBIT_NO_SETUID_FIXUP by default?
>
> Yes, because it's what userspace expects.  If you prefer to run in
> a full POSIX capabilities environment with unprivileged root, you
> can have init set SECBIT_NO_SETUID_FIXUP and SECBIT_NOROOT and
> tune userspace to do the right thing, but it's not trivial.
>
> -serge
>
