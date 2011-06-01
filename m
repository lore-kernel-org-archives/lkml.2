Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab1FAAfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 20:35:38 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:56470 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758489Ab1FAAfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 20:35:37 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 May 2011 20:35:37 EDT
Date: Tue, 31 May 2011 19:28:54 -0500
From: lkml@pengaru.com
To: linux-kernel@vger.kernel.org
Subject: bdi_min_ratio never shrinks, ultimately preventing valid setting of min_ratio
Message-ID: <20110601002854.GV5753@shells.gnugeneration.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/page-writeback.c
There is a static global bdi_min_ratio used for policing the setting of
per-bdi min_ratio's, to ensure the sum doesn't cross 100.

There is no place in this listing where the value is decremented by the
respective bdi's min_ratio when a bdi is torn down.  This looks like a bug
to me, and I have a situation where I'm unable to set a min_ratio to 1
where the sum of /sys/class/bdi/*/min_ratio does not add up to 100, which
is what triggered this investigation.

Regards,
Vito Caputo
