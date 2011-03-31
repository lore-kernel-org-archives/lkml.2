Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab1CaU3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 16:29:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63808 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab1CaU3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 16:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZVY7V13n+AZSs1uQk2oDIdslejgj2baPkkvkDbc69Bt4DW4rrigmfM1FLdryLo/S1K
         ecv0L/8nrEm4ixTl19u68syqbVBh2qYUKlu6dqdTNq1PBG5xTE1VV0qH+qzJLQXMqTBV
         8WdCosoVinfIpuP1cdbfKB9uOtAham/XhKsQk=
MIME-Version: 1.0
In-Reply-To: <20110331191507.GA5052@Xye>
References: <20110326224408.GA1336@Xye> <20110328144721.GB17872@ghostprotocols.net>
 <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com> <20110329181524.GA5140@Xye>
 <AANLkTi=3Wq3Xt-QFR-FLRQ1kBjpWjaBZNFpOiE_T15WH@mail.gmail.com>
 <20110329204024.GA20824@ghostprotocols.net> <AANLkTinmXdmNX+iCB4svo3QqR6AcwGrasziFJPeu0J=M@mail.gmail.com>
 <20110329211437.GB20824@ghostprotocols.net> <20110331191507.GA5052@Xye>
From: Michael Witten <mfwitten@gmail.com>
Date: Thu, 31 Mar 2011 15:29:12 -0500
Message-ID: <AANLkTi=8YiYNUj0o4=XqrRqmNjUq7zPXVEpsysJ6KbMx@mail.gmail.com>
Subject: Re: [PATCH] Use the environment variable PYTHON if defined
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 14:15, Raghavendra D Prabhu <rprabhu@wnohang.net> wrote:
> Hi,
>    Regarding the point where it warns about python-devel not existing,
> it looks like that existing feature test will pass even when python3 is
> chosen and fail at a later stage. So I made this little change to feature
> test so that it fails when python3 is chosen and perf build succeeds with
> the warning printed rather than failing later.

Good point.

However, try-cc does not run the resulting program after
compiling it, so the test still succeeds.

What you want to do is make the compilation fail;
to do so, move your test here:

  #include <Python.h>

  #if PY_VERSION_HEX >= 0x03000000
    #error "Python 3 is not yet supported; set PYTHON{,_CONFIG}"

  int main(void)
  ...

P.S.
Put your replies below the email quote.
