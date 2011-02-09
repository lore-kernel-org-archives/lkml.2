Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1BIQc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 11:32:58 -0500
Received: from mx0.aculab.com ([213.249.233.131]:41446 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753552Ab1BIQc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 11:32:57 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] misc: add CARMA DATA-FPGA Access Driver
Date: Wed, 9 Feb 2011 16:30:23 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AC45@saturn3.aculab.com>
In-Reply-To: <1297121021-3522-2-git-send-email-iws@ovro.caltech.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] misc: add CARMA DATA-FPGA Access Driver
Thread-Index: AcvHHesaEO51GOw2S4u3gSF5HgD2GABWE5zQ
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>, <linuxppc-dev@lists.ozlabs.org>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> This driver allows userspace to access the data processing 
> FPGAs on the OVRO CARMA board. It has two modes of operation:
> 
> 1) random access
> 
> This allows users to poke any DATA-FPGA registers by using mmap to map
> the address region directly into their memory map.

I needed something similar, but used pread() and pwrite()
to request the transfers.
While this does require a system call per transfer, it allows
the driver to use dma (if available) to speed up the request.
In my case doing single cycle transfers would be too slow.

	David


