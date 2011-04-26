Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1DZXox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 19:44:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:26733 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab1DZXov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 19:44:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,271,1301900400"; 
   d="scan'208";a="426025976"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Nagananda Chumbalkar <Nagananda.Chumbalkar@hp.com>,
        Russ Anderson <rja@sgi.com>
Date: Tue, 26 Apr 2011 16:44:35 -0700
Subject: RE: [PATCH -v2 2/2] x86, MCE: Drop the default decoding notifier
Thread-Topic: [PATCH -v2 2/2] x86, MCE: Drop the default decoding notifier
Thread-Index: AcwEYQPWU+yn4n37R+e00Hg8rgLwTwACffMw
Message-ID: <987664A83D2D224EAE907B061CE93D5301C50FD34B@orsmsx505.amr.corp.intel.com>
References: <1303135222-17118-2-git-send-email-bp@amd64.org>
	<20110419171340.GE6640@elte.hu> <20110419173521.GA25374@aftab>
	<20110419174446.GA13616@elte.hu> <20110420102349.GB1361@aftab>
	<m1hb9mnmqs.fsf@fess.ebiederm.org> <20110426074238.GA22448@aftab>
	<m1y62wk9i8.fsf@fess.ebiederm.org> <20110426214755.GA28314@aftab>
 <m1oc3sir8n.fsf@fess.ebiederm.org>
In-Reply-To: <m1oc3sir8n.fsf@fess.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure.  Although any DIMM that is generating so many correctable errors
> that you need to rate limit it in the kernel, won't likely to confine
> itself to correctable errors.
>
> Still it can happen that things are so bad that you do need to rate
> limit it in the kernel.  Still with those you start wondering "How did
> this machine boot?"  So printk_ratelimit sounds like a fine idea.


Perhaps we really want thresholds rather than rate limits (for corrected
errors).  One corrected error shouldn't cause any but the most paranoid
to worry.  A couple of errors from the same DIMM close together might be
some cause for concern, but could just be happenstance. Enough errors that
rate limiting looks useful, and you are into "something needs to be done"
territory.

-Tony
