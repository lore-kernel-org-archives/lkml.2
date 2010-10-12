Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab0JLXJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 19:09:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46386 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab0JLXJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 19:09:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CB4EAA5.5010605@s5r6.in-berlin.de>
Date: Wed, 13 Oct 2010 01:09:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH unfinished update] firewire: sbp2: parallelize login/inquiry,
 reconnect, and shutdown
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de> <tkrat.1433473bc081daa9@s5r6.in-berlin.de> <tkrat.6dd361dadace9a41@s5r6.in-berlin.de> <tkrat.b190ad8b687a549a@s5r6.in-berlin.de>
In-Reply-To: <tkrat.b190ad8b687a549a@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
>> Maybe I need ordered per-target workqueues.
> 
> No, I actually need per-node ordering.  This device, like my other one
> and apparently most ones on the market actually keep their SCSI logical
> units in separate FireWire units.  Currently firewire-sbp2 is not aware
> that fw_unit instances reside on the same node.
> 
> This is going to be tougher than I hoped.  Maybe I need a driver-global
> Inquiry mutex.  Or move the __scsi_add_device() out of sbp2_login() into
> another work which is scheduled to a "single-threaded" workqueue.

More extensive change but probably with simpler end result:  Let sbp2_probe
and sbp2_update perform login/scsi_add_device/reconnect directly.  sbp2_probe
and sbp2_update are serialized per node, but (since 2.6.36 with cmwq)
parallelized across nodes.
-- 
Stefan Richter
-=====-==-=- =-=- -==-=
http://arcgraph.de/sr/
