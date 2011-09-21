Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1IUMk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 08:40:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40780 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1IUMk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 08:40:26 -0400
Date: Wed, 21 Sep 2011 13:40:18 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org, mikew@google.com,
        saguchi@redhat.com
Subject: Re: [PATCH] efi: Avoid sysfs spew on reboot and panic
Message-ID: <20110921124018.GA22155@srcf.ucam.org>
References: <1316552853-2000-1-git-send-email-mjg@redhat.com>
 <4E795A9C.4040508@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E795A9C.4040508@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 11:31:40AM +0800, Chen Gong wrote:
> >  	mutex_lock(&psinfo->buf_mutex);
> >  	memcpy(psinfo->buf, buf, size);
> >-	id = psinfo->write(type, 0, size, psinfo);
> >+	id = psinfo->write(type, 0, KMSG_DUMP_UNKNOWN, size, psinfo);
> 
> I can't say it is wrong because no real caller for this function, but I can't
> say it is right, yet. KMSG_DUMP_UNKNOWN here looks too arbirary. Do you have
> any reason to use this type here ?

If a function calls pstore_write() directly then we have no type to 
associate with it. It seems worth making this explicit.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
