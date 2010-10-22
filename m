Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab0JVEGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 00:06:50 -0400
Received: from web31805.mail.mud.yahoo.com ([68.142.207.68]:40776 "HELO
	web31805.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751273Ab0JVEGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 00:06:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=g1FyVeXBsYG3vQexhAQ2RWBjKdAb6QrN5d68Cfa/HnkWAmyfyKdPSuXOOxqcDo5q0e7fpn2GbzxgSRK9UKHfQ4QvkF1Ppr3CBAPThMBbnROsra4FQKJXg3Z4aQ85X5pxLXXzFeKFgcvnbXTsTPAcH6yP2ga2rw6HhQwME0ppCck=;
Message-ID: <965283.41083.qm@web31805.mail.mud.yahoo.com>
X-YMail-OSG: cI_fWEAVM1mfcNmF39TJ4akVpxMw48CNWpgZcU5udMLOOcD
 WvimUf9B4e8lSfKo01qztFGk41EhQBfBJOKaX6_ffUifXWsZ5aw2R9GpS.Ea
 _60e5KHdGPTHWGsIM23CZ_LPtkLH0JHDuxxaPRMga4sBoosL52wTg6jBAO1S
 _m7SvlUuhjfsxxI_n6XMSB3XTr6hc9jIwBsbX4kpy6ZGu5mrCvSWwNDzIM5N
 pK6bI1TKK3h9zKu_n7kHrIH45ryTPR05ltiR53LNQJnXY.kETu3yBaQv87c7
 43ZHLrzCLAOa718JebS0dik4zuIZKmZlJA3ZxZfHEGHs0sha1_G95.f82JCx
 u7W6f78wD0U6nltJgtvPKLyMpI7NEWT.UMogG6PWCRl.X8VBkmGc1Qc6eKv2
 BPEOqmU0-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Thu, 21 Oct 2010 21:06:47 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] Allow retrieval of the Caching mode page
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101022000405.GC25431@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 10/21/10, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:
> If you remove this, there are several devices which will
> stop working.
> They will simply go out-to-lunch when the sd_mod driver
> sends a request for
> Mode Page 8.

That's true. But it seems unfair to punish good devices which do support
the Caching mode page.

sd_revalidate_disk() calls in succession sd_read_write_protect_flag(),
sd_read_cache_type() and sd_read_app_tag_own().  The first, asks for all
pages by setting the page code to 0x3F. Surely if the device server
supports the Caching mode page, it will be returned. The second call, asks
only for the Caching mode page, and here is where some (few?) broken
devices fail.

If the skip_ms_page_8 is set, why not request all pages, and see if the
Caching mode page is part of the parameter data.

Anyone willing to code that up in sd_read_cache_type()?

