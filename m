Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1EPUCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:02:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56508 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1EPUCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:02:14 -0400
MIME-Version: 1.0
In-Reply-To: <20110516195258.GL21345@caffeine.csclub.uwaterloo.ca>
References: <20110511155211.GA21349@caffeine.csclub.uwaterloo.ca>
 <9389EE59E16E9447AFB481039183BCF4117B10@039-SN1MPN1-005.039d.mgd.msft.net>
 <20110512151113.GE21345@caffeine.csclub.uwaterloo.ca> <BANLkTikGM=v09KE-J_KOvbSNhQx3MmR0cA@mail.gmail.com>
 <20110516195258.GL21345@caffeine.csclub.uwaterloo.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 16 May 2011 14:01:54 -0600
X-Google-Sender-Auth: SpXYIT1-pQPSJ3m6sxjqoi42S0Y
Message-ID: <BANLkTimJgZmghcTTtR8ZmU5mWfwG=iSv7g@mail.gmail.com>
Subject: Re: spi_fsl_spi broken when compiled as module by b36ece832512c1a0afa54ff0a56d63492a1caf08
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Hu Mingkai-B21284 <B21284@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 1:52 PM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
>> >  struct mpc8xxx_spi_probe_info *to_of_pinfo(struct fsl_spi_platform_data *pdata)
>> >  {
>> >        return container_of(pdata, struct mpc8xxx_spi_probe_info, pdata);
>> >  }
>> > +EXPORT_SYMBOL(to_of_pinfo);
>>
>> Hmmm,. this is not so good because it exports rather generically named
>> functions out to the global namespace.  These functions should be
>> renamed to have an mpc8xxx_spi_ prefix before exporting.
>>
>> Otherwise this patch looks good.
>
> Hmm, yeah it did look like a crappy function name, but I just wanted to
> fix the problem, not try to guess what the author of the code intended.
> Prefixing it makes sense.

Alternately, you can move that function to the common header as a
static inline.  It's just a container_of() wrapper after all, so
moving it would probably be better.

g.
