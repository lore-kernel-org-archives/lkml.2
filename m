Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1HECdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 22:33:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab1HECdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 22:33:13 -0400
Date: Thu, 4 Aug 2011 22:33:09 -0400
From: Dave Jones <davej@redhat.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, tom.l.nguyen@intel.com,
        yanmin.zhang@intel.com
Subject: Re: [rfc] suppress excessive AER output
Message-ID: <20110805023309.GA20447@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Arnaud Lacombe <lacombar@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, tom.l.nguyen@intel.com,
	yanmin.zhang@intel.com
References: <20110803223407.GA20646@redhat.com>
 <CACqU3MXaHJ+AnUpkeBWg=aHp3iJBR=uXgr22pinAdu-wgeoCuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACqU3MXaHJ+AnUpkeBWg=aHp3iJBR=uXgr22pinAdu-wgeoCuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 10:24:07PM -0400, Arnaud Lacombe wrote:
 > Hi,
 > 
 > On Wed, Aug 3, 2011 at 6:34 PM, Dave Jones <davej@redhat.com> wrote:
 > > I have a machine that has developed some kind of problem with
 > > its onboard ethernet.  It still boots, but spewed almost 1.5G of text
 > > (2381585 instances of the warning below) before we realised what
 > > was going on, and blacklisted the igb driver.
 > >
 > > Is it worth logging every single error when we're flooding like this ?
 > > It seems unlikely that we'll find useful information in amongst that much data
 > > that wasn't already in the first 100 instances.
 > >
 > > I picked 100 in the (untested) example patch below arbitarily, but the exact
 > > value could be smaller, or slightly bigger..
 > >
 > > could we do something like this maybe ?
 > >
 > Please do not reinvent the wheel and use printk_ratelimited().

It's a different wheel.

printk_ratelimit slows down the output, but would still cause a lot of messages.

my diff turns it off completely after a threshold (apart from at the ulong wrap,
which I overlooked).

	Dave

