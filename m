Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab1JRPok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:44:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43884 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab1JRPoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:44:38 -0400
Date: Tue, 18 Oct 2011 11:48:28 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: iommu@lists.linux-foundation.org
Subject: IOMMU keeping mapping over long period of time
Message-ID: <20111018154828.GA4201@homer.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For GPU we are entertaining the idea of keeping pci/dma mapping of page
around for the whole life span of GPU object (which can be as long as
the computer uptime). Here we are talking about possibly several GB of
data.

GPU for which we are interested have dma mask of 40bits at least, thus
they can work with high mem page. My main concern is when an iommu is
active, such amount of continuously mapped page might exhaust the iommu
address space. My understanding is that Intel & AMD iommu are capable of
growing their address space but is it somethings we can rely on ?

Cheers,
Jerome
