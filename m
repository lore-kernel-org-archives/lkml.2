Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037Ab1GRVBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 17:01:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58330 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1GRVA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 17:00:59 -0400
Date: Mon, 18 Jul 2011 22:00:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tony Luck <tony.luck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, mikew@google.com
Subject: Re: [PATCH 4/9] pstore: Allow the user to explicitly choose a
 backend
Message-ID: <20110718210051.GA815@srcf.ucam.org>
References: <1311021033-7483-1-git-send-email-mjg@redhat.com>
 <1311021033-7483-5-git-send-email-mjg@redhat.com>
 <CA+8MBbJMHK1e_wGC9EE+8neVc2j9Y8Ut4vzPiGh2umNZENsK1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+8MBbJMHK1e_wGC9EE+8neVc2j9Y8Ut4vzPiGh2umNZENsK1Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 01:58:28PM -0700, Tony Luck wrote:
> On Mon, Jul 18, 2011 at 1:30 PM, Matthew Garrett <mjg@redhat.com> wrote:.
> > +
> > +               Pstore only supports one backend at a time. If multiple
> > +               backends are available, the preferred backend may be
> > +               set by passing the pstore.backend= argument to the kernel
> > +               or writing to /sys/module/pstore/parameters/backend .
> > \ No newline at end of file
> 
> Maybe we should have a newline :-)

True...

> We don't allow backends to be unregistered (currently) - Do you think it would
> be helpful to mention in this text that you cannot change your mind and
> switch to a different back end once you have registered one? Writing
> to /sys/module/... sounds a lot more flexible than what reality will allow.

Mm. Yes, the lack of unregistration does make that less helpful. Perhaps 
best to make that unwritable.

> 
> > +       if (backend && strcmp(backend, psi->name)) {
> > +               spin_unlock(&pstore_lock);
> > +               return -EBUSY;
> > +       }
> 
> EBUSY doesn't feel like the right error here (and we are using that
> to indicate that some other backend is already registered).  Not
> sure what is the right one though. ENOENT? EINVAL?

EINVAL, I guess?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
