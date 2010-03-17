Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab0CQDlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:41:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:51285 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab0CQDlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:41:12 -0400
Message-ID: <4BA05004.3040405@kernel.org>
Date: Wed, 17 Mar 2010 12:44:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Kevin Easton <caf@guarana.org>
CC: James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: ATA 4 KiB sector issues.
References: <20100317025101.GA13339@guarana.org>
In-Reply-To: <20100317025101.GA13339@guarana.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 03:41:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/17/2010 11:51 AM, Kevin Easton wrote:
> Can't we fix the problem by defaulting to aligning partitions to
> start on an LBA that is a multiple of 64260 ?
> 
> Such partitions will always be 4KiB-aligned, *and* start-of-cylinder
> aligned (assuming 255/63, as seems to be the norm).
> 
> Sure, that reduces your partition granularity to almost-32-MiB, but
> that's pretty small potatoes these days (and it's only a *default*, so
> you could always override that if you really cared, and didn't need 
> the compatibility).

The only thing we can gain by that is possible compatibility w/ very
old operating systems (<=w2k, BTW, it would be great if someone can
actually test it).  Plus, breaking the first cylinder assumption might
not be always safe to begin with.  I personally don't think it's
something worth departing from the behavior most vendors would assume
from now on (1MiB alignment).  It should be enough and safer to
provide a mechanism to choose legacy alignment if someone is trying to
put something which is older than a decade there.

Thanks.

-- 
tejun
