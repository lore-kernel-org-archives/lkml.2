Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab0FBS00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 14:26:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55986 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774Ab0FBS0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 14:26:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C06A246.9030405@s5r6.in-berlin.de>
Date: Wed, 02 Jun 2010 20:26:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: core: check for 1394a compliant IRM,	fix inaccessibility
 of Sony camcorder
References: <AANLkTimIFRbKWYjFd56acxT2A6nnH6l3-7Q_UyORnonW@mail.gmail.com>	<4C017477.8000008@s5r6.in-berlin.de>	<4C0284E7.3050803@s5r6.in-berlin.de>	<tkrat.740b506673ccbf6d@s5r6.in-berlin.de>	<htu993$60f$1@dough.gmane.org>	<4C02B483.9080802@s5r6.in-berlin.de>	<htuebt$l80$1@dough.gmane.org>	<hu0jnr$10b$1@dough.gmane.org> <hu22tj$ne4$1@dough.gmane.org>
In-Reply-To: <hu22tj$ne4$1@dough.gmane.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H.S. wrote:
> H.S. wrote:
>> So, what is verdict?
> 
> Should have been "So, what is the verdict?"

I committed the patch to linux1394-2.6.git now, exposed it in the
linux-next branch, and will send a pull request sometime next week.

I marked the commit to be back-merged into the stable kernel branches
(2.6.32.y and newer).  Distributors will pick it up from there at their
leisure, or earlier if they get a distro bug report that points them to
the commit.

Thanks for testing the patched kernel.

> Anyway, just wanted to give a little additional information, in case
> this is significant. While testing the camcorder on a different Debian
> machine running Unstable and 2.6.32-5-686-bigmem kernel, I did not face
> the face problem I reported earlier. On this new machine, I was able to
> connect the camera and grab a footage using dvgrab. The syslog had this
> in it:
> May 30 19:31:42 blue kernel: [ 5203.926694] firewire_core: skipped bus generations, destroying all nodes
> May 30 19:31:42 blue kernel: [ 5204.424019] firewire_core: rediscovered device fw0
> May 30 19:31:42 blue kernel: [ 5204.516343] firewire_core: created device fw1: GUID 08004601024aca36, S100
> May 30 19:31:42 blue kernel: [ 5204.516346] firewire_core: phy config: card 0, new root=ffc1, gap_count=5
> May 30 19:31:42 blue kernel: [ 5204.525209] firewire_core: skipped bus generations, destroying all nodes
> May 30 19:31:43 blue kernel: [ 5205.024019] firewire_core: rediscovered device fw0
> May 30 19:31:43 blue kernel: [ 5205.116912] firewire_core: rediscovered device fw1

I suppose either the local node became root node (node with highest node
ID) and thus the camcorder stopped doing bus management things, or the
camcorder chose the optimum gap count 5 for some reason and thus the
Linux node saw no reason to do its bus management routine.  If you are
very curious, you can look at node IDs and gap counts and more with the
FireWire inspection utility gscanbus.
-- 
Stefan Richter
-=====-==-=- -==- ---=-
http://arcgraph.de/sr/
