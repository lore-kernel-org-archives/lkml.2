Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab1JCQCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:02:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43517 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab1JCQCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:02:07 -0400
Subject: RE: [PATCH v2 0/3] staging: zcache: xcfmalloc support
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>,
        gregkh@suse.de, devel@driverdev.osuosl.org, cascardo@holoscopio.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
In-Reply-To: <863f8de5-a8e5-427d-a329-e69a5402f88a@default>
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com>
	 <20110909203447.GB19127@kroah.com> <4E6ACE5B.9040401@vflare.org>
	 <4E6E18C6.8080900@linux.vnet.ibm.com> <4E6EB802.4070109@vflare.org>
	 <4E6F7DA7.9000706@linux.vnet.ibm.com> <4E6FC8A1.8070902@vflare.org>
	 <4E72284B.2040907@linux.vnet.ibm.com>
	 <075c4e4c-a22d-47d1-ae98-31839df6e722@default 4E725109.3010609@linux.vnet.ibm.com>
	 <863f8de5-a8e5-427d-a329-e69a5402f88a@default>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Oct 2011 08:59:16 -0700
Message-ID: <1317657556.16137.696.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11100315-8974-0000-0000-000000991FE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan/Nitin,

I've been reading through Seth's patches a bit and looking over the
locking in general.  I'm wondering why preempt_disable() is used so
heavily.  Preempt seems to be disabled for virtually all of zcache's
operations.  It seems a bit unorthodox, and I guess I'm anticipating the
future screams of the low-latency folks. :)

I think long-term it will hurt zcache's ability to move in to other
code.  Right now, it's pretty limited to being used in conjunction with
memory reclaim called from kswapd.  Seems like something we ought to add
to the TODO list before it escapes from staging/.

-- Dave

