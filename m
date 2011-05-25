Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1EYFnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 01:43:02 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44006 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab1EYFnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 01:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yIA79/1AZPIPsH4kQxZ+vZ8WFnBO8eVCf9YMA+FH2TzIY4vXMgbUTCbx+QqI2St57J
         S0hw9DhimfK8tyQAxHVgB6GOpdZM2Lt5LLw/39snJBYx9ongpMed21CmFPnyJaUZ4wQ9
         4j/f5uOcYmaqHMpfdTBv7vwYUPi3DmNH7gKvw=
MIME-Version: 1.0
In-Reply-To: <1306301804-12319-1-git-send-email-lacombar@gmail.com>
References: <1306301804-12319-1-git-send-email-lacombar@gmail.com>
Date: Wed, 25 May 2011 01:42:59 -0400
Message-ID: <BANLkTim9a7RcjDk=DkXNZ-Foeo3E14Rd3Q@mail.gmail.com>
Subject: Re: [PATCH] kconfig: do not overwrite symbol direct dependency in assignment
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 25, 2011 at 1:36 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Considering the following configuration:
>
> config F
>    bool "F"
>
> choice AB
>    bool "AB"
> config A
>    bool "A"
> config B
>    bool "B"
> endchoice
>
> if A
> config D
>    bool
>    default y if F
>    select E
> config E
>    bool "E"
> endif
>
> if B
> config D
>    bool
>    default y if F
>    select E
> config E
>    bool "E"
> endif
>
> The following configuration:
>
> CONFIG_F=y
> CONFIG_A=y
> CONFIG_D=y
> CONFIG_E=y
>
d'oh! this should have read:

 CONFIG_F=y
 CONFIG_A=y
 # CONFIG_B is not set
 CONFIG_D=y
 CONFIG_E=y

but I missed the leading space, and git decided to eat the assignment
of CONFIG_B.

sorry about that,
 - Arnaud
