Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab1BAMpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 07:45:38 -0500
Received: from coyote.quickmin.net ([217.14.112.24]:53345 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab1BAMpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:45:36 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=1LZ2Ur40zA5XW34l0TFacOraXAot3/Yjps18Y0LXiaHt2eicm8WPOTJMPaHOEqyld5fO+3zxve8dNXWlrDtMv5lQsgMmJsS/GrJLQ6oTIpakf4q24tm2iLKy7Xynug0JGz2eJIAtJ2jDXhny9GNyZKTSl2ebI9fXRNaqIhh6/CU=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Joe Perches <realty@perches.com>
Subject: Re: [PATCH 0/2] Fixed proposal to add dynamic debug feature for print_hex_dump
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-default; KDE/4.5.5; x86_64; ; )
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
References: <201012031517.35062.roman.fietze@telemotive.de> <201101140943.53142.roman.fietze@telemotive.de> <1295029146.4099.71.camel@Joe-Laptop>
In-Reply-To: <1295029146.4099.71.camel@Joe-Laptop>
MIME-Version: 1.0
X-TNEFEvaluated: 1
Message-ID: <201102011345.30618.roman.fietze@telemotive.de>
Date: Tue, 1 Feb 2011 13:45:30 +0100
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 01.02.2011 13:45:30,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 01.02.2011 13:45:32,
	Serialize complete at 01.02.2011 13:45:32
Content-Transfer-Encoding: 7bit
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe,

On Friday, 14.January.2011 19:19:06 Joe Perches wrote:

> A high percentage of these print_hex_dump() uses are
> (,,, 16, 1, buf, len, true) so there's some value
> in doing this.

I found some calls using 16 and 32 bit words to dump their data, e.g.
in UBIFS, NFC, USB IP, MTD Tests and libata, so I think we should
rather ask the callers to add the "16, 1," for byte dumps instead of
rendering hex_dump_xx unusable in quite some cases by defaulting to
byte dumps.

> I suggest simplifying naming to just hex_dump_<level>.

Done.

> Adding a hex_dump_printk function to hexdump.c

If the first of the following two patches will be accepted I can work
on that issue.


Roman

-- 
Roman Fietze              Telemotive AG Buero Muehlhausen
Breitwiesen                             73347 Muehlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de
