Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab0HRNSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:18:01 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48524 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0HRNR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:17:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C6BDD77.5040301@s5r6.in-berlin.de>
Date: Wed, 18 Aug 2010 15:17:43 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Peter Zijlstra <peterz@infradead.org>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>	 <1281994939.1926.2075.camel@laptop> <1281997633.3683.50.camel@jlt3.sipsolutions.net> <4C6AB741.9050804@s5r6.in-berlin.de>
In-Reply-To: <4C6AB741.9050804@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Johannes Berg wrote:
>> I'm convinced it's a false positive though, question is how to shut it
>> up :-)
> 
> Is there anyway to differentiate the lockdep naming of shost->host_lock
> (initialized in scsi_host_alloc) at runtime by means of the
> scsi_host_template instance given to scsi_host_alloc?

So, even though the part of the lockdep report about nesting with a SCSI
host lock was a false positive, it did motivate Clemens' del_timer_sync
-> del_timer replacement, so it was helpful after all.  I guess there is
no immediate need anymore to do something about the conflation of
shost->host_lock instances.
-- 
Stefan Richter
-=====-==-=- =--- =--=-
http://arcgraph.de/sr/
