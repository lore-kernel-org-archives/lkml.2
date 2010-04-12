Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab0DLGCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:02:44 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:58197 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500Ab0DLGCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:02:43 -0400
Message-ID: <4BC2B770.3020501@st.com>
Date: Mon, 12 Apr 2010 08:02:24 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: re-adding clocksource_get_next ?
References: <4BBECED7.4010004@st.com> <x2p1f1b08da1004091358z1d185aacya6c0fa2f55322fc7@mail.gmail.com>
In-Reply-To: <x2p1f1b08da1004091358z1d185aacya6c0fa2f55322fc7@mail.gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello John,

john stultz wrote:
> On Thu, Apr 8, 2010 at 11:53 PM, Giuseppe CAVALLARO
> <peppe.cavallaro@st.com> wrote:
>> Hello!
>> this function was removed in the past but I've not clear all the details.
>> While testing LLTng, I wrote the patch, in attachment, that re-adds it
>> again.
>> The clocksource_get_next returns the first clock source available
>> (without looking at the rating).
>> In my environment, a clock source is a TMU channel (e.g. TMU1) and,
>> indeed, clocksource_get_next works fine.
> 
> Could you provide some more details as to why you need raw access to
> the clocksource, instead of using something like ktime_get(),
> getrawmonotonic() or sched_clock()?

I wanted to directly read the value of the TCNT register of a TMU
channel registered as clocksource in an SH platform.
My idea was to get the first clocksource available and than use the read
hook to get its raw value.
Indeed, on SH4, the clocksource_get_next returns the TMU channel 1
(usually registered as clocksource); the clk->reads points to
sh_tmu_clocksource_read (drivers/clocksource/sh_tmu.c). This returns the
value of the timer count register (TCNT).

Best Regards,
Giuseppe

> thanks
> -john

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJLwrdqAAoJEAm9vY9Tshdv2HAH/RdL0cKvYAjcnS4lzJGppbzX
NdZL6WTW3wNfrqBzm7g8OGy+ZX3Fd+yQKbR41qGcH1agQ5JKMN5aDLzVhw91CG9o
aJAqsYyMVxetDa1iDxmqHpwctbeQfACwxztX1wceG/YuAGM7XXHevVN/ywQZn10c
qxSb+bgNr4T489f7EkCLTwvk+iutRY0TRQIJX0/40qIO/UGpjiNODkfbCXAaU2QC
Cw5zq59UY7gvbnrAmjthxTq91kWqUAunk4UaliSaxV7n+JJziWPKDQ7iXzbSk/sv
CJmec+/1ZmnISBYyjCMtRX5o0xDjxfWgWSVI7YiS7lPOtV+b/QN4a5gr/g1UP7w=
=wuHC
-----END PGP SIGNATURE-----
