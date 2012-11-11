Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab2KKXK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 18:10:56 -0500
Received: from gherkin.frus.com ([192.158.254.49]:42285 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab2KKXKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 18:10:55 -0500
Date: Sun, 11 Nov 2012 17:10:53 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Cc: mcree@orcon.net.nz
Subject: Re: 3.7.0-rc4 build failure on alpha: MPILIB
Message-ID: <20121111231053.GA11769@gherkin.frus.com>
References: <20121105135313.GA3979@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121105135313.GA3979@gherkin.frus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 07:53:13AM -0600, Bob Tracy wrote:
> With digital signature verification support (SIGNATURE, MPILIB) enabled
> on the Alpha platform, I get the following during the MODPOST section of
> the build:
> 
> ERROR: "__udiv_qrnnd" [lib/mpi/mpi.ko] undefined!
> 
> Current compiler is gcc-4.6.3

Got a workaround.  I'll leave it to the "powers that be" for a proper
fix.  Issue is "__udiv_qrnnd" is part of "arch/alpha/math-emu" and is
built-in.  If MPILIB is built as a module, you get the undefined symbol
error.  If "CONFIG_MPILIB=y" (built-in), no undefined symbol issue.

My best guess is, the proper solution will involve either tightening the
configuration dependencies a bit, or making sure required symbols are
properly exported for use by modules.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "Build a man a fire, he'll be warm for a day.  Set
rct@frus.com       |   a man on fire, he'll be warm for the rest of his
                   |   life."	-- David Burge (Iowahawk)
------------------------------------------------------------------------
