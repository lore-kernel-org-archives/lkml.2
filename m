Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab2HQJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:27:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:20602 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab2HQJ1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:27:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,783,1336374000"; 
   d="scan'208";a="203409557"
Date: Fri, 17 Aug 2012 17:27:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>
Subject: Re: BUG: unable to handle kernel paging request in usb_match_id()
Message-ID: <20120817092708.GA30371@localhost>
References: <20120805025938.GA8954@localhost>
 <20120805165826.GB13913@kroah.com>
 <20120817020046.GA24406@localhost>
 <20120817034825.GC7770@kroah.com>
 <20120817054441.GA28434@localhost>
 <87wr0xnbnm.fsf@nemi.mork.no>
 <87sjblnaye.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sjblnaye.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjørn,

> -static const struct usb_device_id id_table[] __devinitconst = {
> +static const struct usb_device_id id_table[] = {

Good catch! It magically fixed the oops. So that id_table was
freed sometime with __devinitconst?

There are some more "usb_device_id .* __devinitconst" users in the system,
Shall they be fixed as well?

Thanks,
Fengguang
