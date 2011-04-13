Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab1DMOjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:39:39 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49799 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab1DMOji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:39:38 -0400
Date: Wed, 13 Apr 2011 16:39:17 +0200
From: Borislav Petkov <bp@amd64.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: Re: [PATCH 2/3] x86, MCE: Drop default decoding notifier
Message-ID: <20110413143917.GD2791@aftab>
References: <20110413132409.GB1900@gere.osrc.amd.com>
 <1302701810-2471-2-git-send-email-bp@amd64.org>
 <4DA5ACB2.1070505@redhat.com>
 <20110413141829.GE1987@aftab>
 <4DA5B1B1.5090905@redhat.com>
 <20110413142648.GB2791@aftab>
 <4DA5B403.2010203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA5B403.2010203@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 10:32:35AM -0400, Prarit Bhargava wrote:
> 
> >> .. right ... but we would still see nonsensical messages before the
> >> panic, which will confuse the end user.  IMO, dump the messages unless
> >> it's UC.  And we shouldn't print out the human readable message at all.
> >>     
> > I'd still leave the "mcelog ... " line though as a hint.
> >
> >   
> 
> :)
> 
> There are no messages -- that's part of the problem.  We're asking a
> user to do something for a message that doesn't exist ...

Yes and no - in the UC case you get all the MCA registers dumped in
print_mce() - and those you want to decode. In the CE case, we won't be
issuing any with the default notifier removed. I just sent you a -v2, I
think it should do what we want.

Or am I missing something...?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
