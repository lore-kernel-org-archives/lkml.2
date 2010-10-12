Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab0JLRmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 13:42:33 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65214 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab0JLRmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 13:42:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ww2VQfQgaje6BehAOu2AVEaLZup9iiHztsB6XiMb+N3IrxDzJZnxe++ILG9XqBgaUj
         kKGQYJ5uwZwawJh7I5KbIWutwW8N0l1J0Foybx37zpYtHBM7LaY4sy7eqRQbpC2eFjSV
         Pd9ACyRJcbLh6DF0p9KjiMeWNbRkQXeycOQa8=
MIME-Version: 1.0
In-Reply-To: <AANLkTikjp=dpOOfjnvg=ivkb40_dE+oRLSEkzrycwirV@mail.gmail.com>
References: <20101012163519.a88f2040.sfr@canb.auug.org.au>
	<1286895206-3030-1-git-send-email-linville@tuxdriver.com>
	<AANLkTikjp=dpOOfjnvg=ivkb40_dE+oRLSEkzrycwirV@mail.gmail.com>
Date: Tue, 12 Oct 2010 13:42:30 -0400
X-Google-Sender-Auth: Q6Qd-8bMYqzyTVYHgyiw3HPasEc
Message-ID: <AANLkTim0ryZ29w0ud9=sSbV6LdZhjW410ptpf3XJDYkm@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fix build break from "ath5k: Print out opmode in debugfs"
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Ben Greear <greearb@candelatech.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 12:54 PM, Bob Copeland <me@bobcopeland.com> wrote:
>> +#ifdef CONFIG_ATH_DEBUG
>>        ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
>>                  sc->opmode,
>>                  ath_opmode_to_string(sc->opmode) ?
>>                  ath_opmode_to_string(sc->opmode) : "UKNOWN");

Just one other bikeshed color:

if ath_opmode_to_string() returned "UNKNOWN" in the failure case,
we wouldn't need the double-call above.  Yes, it's used by ath9k
too, but IMHO a debugging function that only converts some of the
possible values to strings is pretty developer unfriendly.

That said, I still think tracepoints are a nicer way to do this
kind of thing (you can even do symbolic names for enums).

-- 
Bob Copeland %% www.bobcopeland.com
