Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1HYCq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 22:46:29 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43192 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226Ab1HYCq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 22:46:27 -0400
X-Sasl-enc: GE1q0SoO/Qm/Ije5ZbIlHmI4t0+mllkeOYyirSToGJiy 1314240386
Date: Wed, 24 Aug 2011 19:40:14 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
 mod_devicetable.h
Message-ID: <20110825024014.GB6131@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-3-git-send-email-kys@microsoft.com>
 <20110823224157.GA9641@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B236E@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110824025913.GC30779@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B27B9@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110824201144.GA28667@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B29C8@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <6E21E5352C11B742B20C142EB499E048081B2AF2@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B2AF2@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 02:27:56AM +0000, KY Srinivasan wrote:
> Since I don't have any (current) use for the driver_data pointer, I have gone ahead
> and cleaned up the first 74 patches without adding the driver_data. 
> With the mushing of the patches   you had proposed this is about
> a 60 patch series and addresses all the other comments you had in the first 74 patches.
> I hope I have gotten the "right" granularity now.   If it is ok with you, I could send these 
> out for your consideration.

Please do.

But if you do, do you mind if I add the driver_data pointer, so you can
blame me later if no one uses it?  :)

> The only unresolved issue in the remaining patches (75 - 117) is the reference counting
> issue we have been debating. As I noted in my earlier emails on this topic, the reference
> counting has been there for a long time and I am reluctant get rid of that code without 
> additional testing/analysis. So I want to propose the following options:
> 
> 1) Keep the existing code and I will skip the patches that cleaned up the reference counting
> 
> 2) Take the cleanup that I have implemented
> 
> In either case, I would further test and analyze this code to see if (a) the race condition that is being
> addressed is valid and (b) if there is a different mechanism that could be used to deal with it. Given
> the gaping holes in the current implementation, my personal preference would be to go with the 
> second option. Let me know what you want me to do here.  

Ok, that sounds acceptable, but don't add the lock to the hv_driver, or
is that needed right now?

thanks,

greg k-h
