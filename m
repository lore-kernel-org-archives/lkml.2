Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab1EIPsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:48:02 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:49065 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1EIPsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:48:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=v6FnRPXQuoR+KAL8i+qcZxF6VkjEV/swQgriVp9Mr9wb30xzdE8mnjc2Hn3yKCxKAX
         cLCCcA5FmSK5sDi6XnEFzgc/L7lflXtutJqnctD6ze4PZpjJ85sJTC5GiMWvH5BCZEGO
         fYy7coVHWoHg5rKGdSQMucRg/pKEQPkwAoZMs=
MIME-Version: 1.0
In-Reply-To: <20110509152941.GD13275@khazad-dum.debian.net>
References: <BANLkTinWna2sDDjbNC5xyGX3ELROs=Wd0w@mail.gmail.com>
 <20110509144546.GB13275@khazad-dum.debian.net> <BANLkTikB2TFF12vdwLqV9NRw4meEyDjvdA@mail.gmail.com>
 <20110509152941.GD13275@khazad-dum.debian.net>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 9 May 2011 11:47:40 -0400
X-Google-Sender-Auth: py_h4Jye_OkWPPHC5qgt7uLI9e4
Message-ID: <BANLkTi=Cmhvhnq-dNda8q0AvUBarpyEjyQ@mail.gmail.com>
Subject: Re: [ibm-acpi-devel] [RFC] Controlling the ThinkPad battery charger
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: ibm-acpi-devel@lists.sourceforge.net, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 11:29 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Mon, 09 May 2011, Andrew Lutomirski wrote:
>> > The SBS interface exposes more data about the battery, including
>> > per-cell-group voltage and pack microcontroller aging counters, alarms, and
>> > the "needs to get through the fuel-gaugue reset procedure" semasphore.
>>
>> If I'm feeling really motivated, I'll look at that.  I'm currently
>> more interested in the charging thresholds, though, which I think is
>> independent of the choice of SBS vs ACPI to access the battery state.
>> (From a quick glance at the SBS spec, you can inhibit charging
>> entirely but you can't ask for thresholds.  I assume that the EC takes
>> care of that.  If I'm wrong, please tell me, but SMAPI seems like a
>> fine way to access the thresholds.)
>
> Yeah, SMAPI is the safest way to deal with all this.  It is an interface
> layer that Lenovo is not fond of breaking (or touches very rarely.  Amounts
> to the same in the end).
>
> SBS does not take care of thresholds, indeed.  The EC does (and I know how
> to program the threshold in a few models, if you do want to test it in your
> X220, I can send you the information.  It is safe to test if you use it
> together with SMAPI to cross-check).

That would be great.  I think it's EC register 0x24 for the BAT0 stop
threshold and EC register 0x25 for the BAT1 stop threshold.  If you
have any hints about the start threshold I can test them, but I
suspect that, in the X220, the EC figures out the start threshold on
its own.

>
> The SBS ACPI interface would be useful to provide a single driver that can
> replace the ACPI battery one to deliver full functionality in one place.
>

I'll save that for later :)

--Andy

> --
>  "One disk to rule them all, One disk to find them. One disk to bring
>  them all and in the darkness grind them. In the Land of Redmond
>  where the shadows lie." -- The Silicon Valley Tarot
>  Henrique Holschuh
>
