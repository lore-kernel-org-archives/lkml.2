Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2H0Tic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 15:38:32 -0400
Received: from gate.in-addr.de ([212.8.193.158]:45299 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752403Ab2H0Tib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 15:38:31 -0400
X-Greylist: delayed 933 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2012 15:38:30 EDT
Date: Mon, 27 Aug 2012 21:22:27 +0200
From: Lars Marowsky-Bree <lmb@suse.com>
To: Toshi Kani <toshi.kani@hp.com>, wim@iguana.be,
        linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, thomas.mingarelli@hp.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] hpwdt: Fix kdump issue in hpwdt
Message-ID: <20120827192227.GJ18709@suse.de>
References: <1346093544-12007-1-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1346093544-12007-1-git-send-email-toshi.kani@hp.com>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-08-27T12:52:24, Toshi Kani <toshi.kani@hp.com> wrote:

> kdump can be interrupted by watchdog timer when the timer is left
> activated on the crash kernel. Changed the hpwdt driver to disable
> watchdog timer at boot-time. This assures that watchdog timer is
> disabled until /dev/watchdog is opened, and prevents watchdog timer
> to be left running on the crash kernel.

How does this protect against the system hanging again in the crash
kernel, or possibly hardware caches to flush more data to shared
storage?

(I'm asking from the perspective of the hpwdt being used as a fencing
mechanism in a cluster setting.)

Or is the argument that it's "very unlikely" that a system in such a
state would not make it far enough into the crash kernel?


Regards,
    Lars

-- 
Architect Storage/HA
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 21284 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

