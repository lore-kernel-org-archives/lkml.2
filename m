Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab0GGUdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 16:33:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57663 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752924Ab0GGUdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 16:33:06 -0400
Date: Wed, 7 Jul 2010 21:39:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andreas Dilger <andreas.dilger@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
       Neil Brown <neilb@suse.de>, hch@infradead.org, viro@zeniv.linux.org.uk,
       adilger@Sun.COM, corbet@lwn.net, serue@us.ibm.com,
       hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle
 syscalls
Message-ID: <20100707213921.2edbb3a1@lxorguk.ukuu.org.uk>
In-Reply-To: <5920F408-E923-4467-A6A9-6C0923C00927@oracle.com>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<871vbn2mk9.fsf@linux.vnet.ibm.com>
	<20100702064108.64034561@notabene.brown>
	<87iq4y29a6.fsf@linux.vnet.ibm.com>
	<20100706161002.GD7387@fieldses.org>
	<87eifgfsez.fsf@linux.vnet.ibm.com>
	<2DC68584-15A8-4C48-8E65-E7EF1DCEEAD0@oracle.com>
	<20100707150535.GB24360@fieldses.org>
	<5920F408-E923-4467-A6A9-6C0923C00927@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you are assuming too much about the use of the file handle.  What I'm interested in is not a userspace file server, but rather a more efficient way to have 10000's to millions of clients to be able to open the same regular file, without having to do full path traversal for each one.

The unix security model requires the traversal. In that respect it
differs significantly from some other OS's that did have handle based
direct opens and treat directories as a lookup and translation index only.

