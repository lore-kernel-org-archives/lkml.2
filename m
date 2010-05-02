Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab0EBVHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 17:07:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20474 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865Ab0EBVHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 17:07:09 -0400
MIME-Version: 1.0
Message-ID: <ae6823b2-09ad-4e9d-ad7e-40922cf9b6c9@default>
Date: Sun, 2 May 2010 14:05:59 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, hugh.dickins@tiscali.co.uk, ngupta@vflare.org,
       JBeulich@novell.com, chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com
Subject: RE: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <1c02a94a-a6aa-4cbb-a2e6-9d4647760e91@default4BD43033.7090706@redhat.com>
 <ce808441-fae6-4a33-8335-f7702740097a@default> <20100428055538.GA1730@ucw.cz>
 <1272591924.23895.807.camel@nimitz> <4BDA8324.7090409@redhat.com>
 <084f72bf-21fd-4721-8844-9d10cccef316@default> <4BDB026E.1030605@redhat.com>
 <4BDB18CE.2090608@goop.org4BDB2069.4000507@redhat.com>
 <3a62a058-7976-48d7-acd2-8c6a8312f10f@default20100502071059.GF1790@ucw.cz>
 <47d6b5d9-beb5-4e49-9910-064d6f7b13e5@default
 20100502200615.GA9051@elf.ucw.cz>
In-Reply-To: <20100502200615.GA9051@elf.ucw.cz>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090203.4BDDE959.00F9:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pavel Machek [mailto:pavel@ucw.cz]
> 
> > > So what needs to be said here is 'frontswap is XX times faster than
> > > swap_ops based solution on workload YY'.
> >
> > Are you asking me to demonstrate that swap-to-hypervisor-RAM is
> > faster than swap-to-disk?
> 
> I would like comparison of swap-to-frontswap vs. swap-to-RAMdisk.
> 									Pavel

Well, it's not really apples-to-apples because swap-to-RAMdisk
is copying to a chunk of RAM with a known permanently-fixed size
so it SHOULD be faster than swap-to-hypervisor, and should
*definitely* be faster than swap-to-in-kernel-compressed-RAM
but I suppose it is still an interesting comparison.  I'll
see what I can do, but it will probably be a couple days to
figure out how to measure it (e.g. without accidentally measuring
any swap-to-disk).
