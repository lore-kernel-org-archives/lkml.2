Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab2GTDDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 23:03:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2GTDDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 23:03:40 -0400
Date: Thu, 19 Jul 2012 23:03:28 -0400
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v2 2/3] Hold multiple logs
Message-ID: <20120720030328.GC5637@redhat.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FDC@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA5F@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28056@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA97@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB2813D@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EADE@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28206@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28206@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 12:39:24AM +0000, Seiji Aguchi wrote:
> 
> Thank you for describing this in detail.
> 
> > Yes - if the OOPs is instrumental in the path leading to the hang/panic - then the OOPS is the first place to look for the root cause of
> > the problem. But it will be a case by case analysis.
> > Sometimes the OOPS might be unconnected. If possible we'd like to log more information to allow detective work to decide whether
> > there is a connection. But as I mentioned above there are severe limits to how much better things are by storing more information.
> 
> I understand the reason why you think 3 or 4 logs are reasonable.
> There are some cases  2nd or 3rd oops is critical....
> 
> I have some enterprise customers who are sensitive for a software failure  and specify panic_on_oops=1.
> In this case, they don't need 3,4 logs. 2 logs  are enough.
> 
> So, kernel parameter should be as follows.
> 
> Log_num =1
>   - For users who want to hold just one log.
> 
> Log_num=2
>   - For users who can handle multiple logs and 1st oops is concerned. (by specifying panic_on_oops=1)
> 
> Log_num=3,4
>  -  for users who care about 2nd or 3rd oops.
> 
> Log_num=5 or more
> Invalid value.

What is the harm of not using this and just letting the number be infinite
(or until EFI runs out of space)?  Is it a big deal if extra failures are
logged?

The hope would be a daemon would clear the old logs out and you never run
out of space.

Cheers,
Don
