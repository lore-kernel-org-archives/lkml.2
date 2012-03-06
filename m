Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030642Ab2CFPW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:22:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030580Ab2CFPWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:22:24 -0500
Date: Tue, 6 Mar 2012 10:22:15 -0500
From: Dave Jones <davej@redhat.com>
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: use-after-free in bluetooth (hci_conn_hash_flush)
Message-ID: <20120306152215.GA20793@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Gustavo F. Padovan" <padovan@profusion.mobi>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
References: <20120305221242.GA2008@redhat.com>
 <20120306085342.GA8432@aemeltch-MOBL1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306085342.GA8432@aemeltch-MOBL1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 10:53:44AM +0200, Andrei Emeltchenko wrote:

 > On Mon, Mar 05, 2012 at 05:12:42PM -0500, Dave Jones wrote:
 > > We had a user report this, which looks like a use after free
 > > in hci_conn_hash_flush(). Probably related to bf4c63252490ba78fb833cc7acf1a5b1900c970f
 > 
 > Yes most probably this is the reason.
 > 
 > > Full report is at https://bugzilla.redhat.com/show_bug.cgi?id=797590
 > 
 > Could you try following commit?
 > 
 > commit 3c4e0df028935618d052235ba85bc7079be13394
 > Author: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
 > Date:   Thu Feb 2 10:32:17 2012 +0200
 > 
 >     Bluetooth: Use list _safe deleting from conn_hash_list

Could you attach the patch ? I'll throw it into a Fedora build for
the user who saw this to test.

	Dave
 
