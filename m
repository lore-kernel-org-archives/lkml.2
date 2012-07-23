Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab2GWONc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:13:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43824 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2GWONb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:13:31 -0400
Date: Mon, 23 Jul 2012 15:13:22 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v2 0/3] efi_pstore: avoid losing critical message
Message-ID: <20120723141322.GA23047@srcf.ucam.org>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FAA@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FAA@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 09:11:44PM +0000, Seiji Aguchi wrote:

> [Patch Descriptions]
>  Patch 1/3 and 2/3 take fist approach, _not_ overwriting entries.
> 
>  Patch 3/3 takes second approach, adding some logic overwriting entries.
> 
>  1/3: Avoid overwriting existing entry
>   This patch just avoid overwriting entries to save the 1st critical message 
>   without being influenced by subsequent events.

I think there's a good argument in favour of this approach. Userspace 
crash report tools should be taught to copy the crash data and then 
remove the existing entries. It avoids any of the complexity associated 
with other approaches and ensures that behaviour is always consistent.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
