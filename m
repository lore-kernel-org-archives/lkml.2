Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab1IVNPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:15:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46208 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1IVNPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:15:12 -0400
Date: Thu, 22 Sep 2011 14:15:05 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org, mikew@google.com,
        saguchi@redhat.com
Subject: Re: [PATCH] efi: Avoid sysfs spew on reboot and panic
Message-ID: <20110922131504.GA11990@srcf.ucam.org>
References: <1316552853-2000-1-git-send-email-mjg@redhat.com>
 <4E795A9C.4040508@linux.intel.com>
 <20110921124018.GA22155@srcf.ucam.org>
 <4E7A9BC6.9070608@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E7A9BC6.9070608@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 10:21:58AM +0800, Chen Gong wrote:
> 于 2011/9/21 20:40, Matthew Garrett 写道:
> >On Wed, Sep 21, 2011 at 11:31:40AM +0800, Chen Gong wrote:
> >>>  	mutex_lock(&psinfo->buf_mutex);
> >>>  	memcpy(psinfo->buf, buf, size);
> >>>-	id = psinfo->write(type, 0, size, psinfo);
> >>>+	id = psinfo->write(type, 0, KMSG_DUMP_UNKNOWN, size, psinfo);
> >>
> >>I can't say it is wrong because no real caller for this function, but I can't
> >>say it is right, yet. KMSG_DUMP_UNKNOWN here looks too arbirary. Do you have
> >>any reason to use this type here ?
> >
> >If a function calls pstore_write() directly then we have no type to
> >associate with it. It seems worth making this explicit.
> 
> Yep, that's the point. We hope to get a more reasonable method to do it, not
> any assumption.

I'm afraid I don't understand. Could you give an example of how you 
think this should look?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
