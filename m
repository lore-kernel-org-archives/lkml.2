Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0KTQ1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 11:27:36 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:48405 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab0KTQ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 11:27:35 -0500
Date: Sat, 20 Nov 2010 17:27:18 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <20101120162718.GF13356@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Andrew Morton <akpm@linux-foundation.org>,
	John Stultz <johnstul@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
 <2783e9e632882e211abde03e9b4ad89a336fd167.1290087480.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2783e9e632882e211abde03e9b4ad89a336fd167.1290087480.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv4 13/17] ntp: add hardpps implementation
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 07:01:06PM +0300, Alexander Gordeev wrote:
> This commit adds hardpps() implementation based upon the original one
> from the NTPv4 reference kernel code from David Mills. However, it is
> highly optimized towards very fast syncronization and maximum stickness
> to PPS signal. The typical error is less then a microsecond.
> To make it sync faster I had to throw away exponential phase filter so
> that the full phase offset is corrected immediately. Then I also had to
> throw away median phase filter because it gives a bigger error itself
> if used without exponential filter.
> Maybe we will find an appropriate filtering scheme in the future but
> it's not necessary if the signal quality is ok.

This patch (and follows) adds a new functionality to PPS subsystem, so
let me suggest to you splitting in two parts this patch set: a first
patch set who fixes up the current PPS implementation, and a second
patch set who adds kernel consumer (and follows).

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
