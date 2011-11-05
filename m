Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab1KEHgr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 03:36:47 -0400
Received: from nm14-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.174]:22838 "HELO
	nm14-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750810Ab1KEHgq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 03:36:46 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Nov 2011 03:36:46 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 349468.96285.bm@omp1002.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=p/NLAD4OFkLqR3sdI0mjQFkpIOEzy3Ulvzl6qAFr3rSxpTKxDzwC9nl6fjYjUu21B6rf4EkYekNyMdmazBym7bXED10gODDJCZSHbqRDfaQPxNUtFrIEi9uleU19lAH5HulNKm28PD9OqIfl+xgFpfHGMHiZiSKIKw3zu6wn0tk=;
X-YMail-OSG: tunVAoEVM1mmhX0j_KBZIUrUheXTp6D1BaRlNAFyW8rt0kl
 HR0cFmqxxp.JRn7FO0UwS_uZqE3.Kxl9AoOKMx6_GublUoe_w5HAZ8YMqwEy
 SCnjMgHEmSb3bAYgiVEE5mUxNpKogOATGckVqrzSxP8A3FCLwm0P.HYCbuNG
 MGKfKRP69uBZeQvsgb19.xV.OTNAIW1GctQtMTEfR7ptaaX52dYPzc0RQ7re
 ASEQtjTNBZlHok07KRuluwSIUdvbDvN1O3lMJnBYbPokKzM15_MSZ8iMF7_i
 9HecrjYntdHhWdujQ.FjGF_d3uABMSGnT3rhTK2uFcsQ4M5n2fzd3FOEQx7b
 79KyMAQ2tlfDFJ1WEVBM7Ac72jLY9ErXu50vSXEg7zoxcdsiEMN.vY6gOnzL
 zQBfpxxHoRlhjzwOSc_rgov4ACFaJRCuWarp9imnTiERYiJReZ50Gcyl1eat
 FqUp_ZYVrQ6m1UlxE5HNbbhoGWc429doJuBKXXjtmyveeZr7hWh5LUSc9KIh
 pagPM2HIa1_TOgbL1ZILkt9pfyg--
X-Mailer: YahooMailWebService/0.8.115.325013
References: <1320269478.98312.YahooMailNeo@web27408.mail.ukl.yahoo.com>  <1320271853.29441.8.camel@localhost.localdomain> <1320273520.29441.12.camel@localhost.localdomain>
Message-ID: <1320478202.932.YahooMailNeo@web121019.mail.ne1.yahoo.com>
Date: Sat, 5 Nov 2011 00:30:02 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Reply-To: Alex Dubov <oakad@yahoo.com>
Subject: Re: Bug: [Toshiba Satellite A200] SD card recognised but not automounted
To: Thomas Meyer <thomas@m3y3r.de>, Lampra <lamprakisa@yahoo.gr>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1320273520.29441.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 

> Am Mittwoch, den 02.11.2011, 23:10 +0100 schrieb Thomas Meyer:
>>  Am Mittwoch, den 02.11.2011, 21:31 +0000 schrieb Lampra:
>>  > 
>>  > Hi,
>> 
>>  Hi Lampra.
> 
> Added maintainer.
> 
>> 
>>  >  this is my first bug report upstream. 
>>  > 
>>  > I use Ubuntu 11.10, when i insert an SD card in my laptop Toshiba
>>  > Satellite A200, the card is recognised but not auto mounted. 
>> 
>>  the correct link seems to be: https://bugs.launchpad.net/bugs/878594
>>  > 
>>  > Lamprakis
>


This may be some sort of conflict between sdhci (which I had not much to
do with) and tifm, which never supported xx12 chipset properly (I only
had xx21 to work with back then, which is somewhat different).

I would start from blacklisting the tifm and trying to get sdhci working
properly, and if it's not working that well, then blacklisting the sdhci
and playing with tifm.

Either approach may require tweaking the pci config registers, which was
a usual game with these chipsets some years ago (done with some sysfs
scripting).

Hope this helps.

