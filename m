Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab0JUGIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 02:08:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43865 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab0JUGIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 02:08:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WM4oACkMhBAmbOcqzFixhPd+M37VnBDqVw3QfyNjZIlQT9VWRvcznuJCIrhqqkZjm9
         593+jL+Ij8NlyxzMPC9IUO8fMdhgLyic+dRa6RCb/FPxxV+VOnuXuugiucrLCgbHpUWK
         PCpbNkIdF2//HdzIfdl5O1OVP2E+6aYKibk2E=
Subject: Re: [tip:x86/mm] percpu: Introduce a read-mostly percpu API
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
In-Reply-To: <4CBFD5A6.3060308@zytor.com>
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
	 <tip-c957ef2c59e952803766ddc22e89981ab534606f@git.kernel.org>
	 <20101021013833.GA21863@sli10-conroe.sh.intel.com>
	 <1287639230.2545.117.camel@edumazet-laptop>  <4CBFD5A6.3060308@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 08:07:57 +0200
Message-ID: <1287641277.4507.23.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 20 octobre 2010 à 22:54 -0700, H. Peter Anvin a écrit :

> L1_CACHE_BYTES is completely pointless, since if there is sharing to
> worry about *at all*, it's probably at the L2 or L3 cache levels.
> 

I see, and we dont have better way to express this hint/requirement than
using PAGE_SIZE or INTERNODE_CACHE_SHIFT ?

In your patch you force a PAGE_SIZE alignement *before*
*(.data..percpu..page_aligned)   

If this alignment is really needed, this should be part of another
patch, since this fixes a previous bug in 2.6.36 ?



