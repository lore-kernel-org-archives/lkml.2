Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1LTXoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:44:08 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44557 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab1LTXoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:44:06 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 21 Dec 2011 00:43:52 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Carl Karsten <carl@personnelware.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] firewire: do not expose globally unique IDs in the
 kernel log
Message-ID: <20111221004352.39dbb43a@stein>
In-Reply-To: <20111221001031.539ef397@stein>
References: <20111220213017.75ff380c@stein>
	<20111220213120.5e275f10@stein>
	<CADmzSSjfFgrAroh8jZfC-q0dNuDgsyoNcUfTik6gBx75zrngFw@mail.gmail.com>
	<20111221001031.539ef397@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 21 Stefan Richter wrote:
> Or you run "grep . /sys/bus/firewire/devices/*/guid | sed s/\\/guid:/\\t/"
> before dvgrab, and you get a list of GUIDs from which you can copy and
> paste.

Or
	(cd /sys/bus/firewire/devices; grep . $(ls -c */guid)) | sed s/\\/guid:/\\t/

for a list in reverse-chronological order of discovery.
Same but narrowed down to AV/C devices:

	(cd /sys/bus/firewire/devices; for fw in $(grep 0x00a02d:0x010001 $(ls -c */units) | cut -f1 -d/); do printf $fw\\t; cat $fw/guid; done)
-- 
Stefan Richter
-=====-==-== ==-- =-=-=
http://arcgraph.de/sr/
