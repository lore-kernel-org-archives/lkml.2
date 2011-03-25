Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab1CYXyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:54:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42353 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab1CYXxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xQlsW9yQbhkMeJ63ZHqIOn2G3K0O/e++FVIC4CvsSkIpKIerlerOWdUtuoQ75NfyZ1
         kkbceI3V72zBWHOkoCoA==
MIME-Version: 1.0
In-Reply-To: <20110325213202.GB21593@redhat.com>
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>
	<20110322150905.GD3757@redhat.com>
	<AANLkTinTiEAFG1F1df380BiDtVFVr=nCsSqhM9__XdQ4@mail.gmail.com>
	<20110322181231.GJ3757@redhat.com>
	<AANLkTi=uB_Wv08xu4SzpjCJ_9isvDPsN=ojTH=wAaDoS@mail.gmail.com>
	<20110323204146.GK13315@redhat.com>
	<AANLkTi=-7gZhEU6qRAt+uGBkb2s2=bkXC81WNScDM6jA@mail.gmail.com>
	<20110325213202.GB21593@redhat.com>
Date: Fri, 25 Mar 2011 16:53:13 -0700
Message-ID: <AANLkTikTLCdHceaD98zxw90Qb=PuTvfALWELa=Yp6UAC@mail.gmail.com>
Subject: Re: [PATCH 0/3] cfq-iosched: Fair cross-group preemption
From: Chad Talbott <ctalbott@google.com>
To: Vivek Goyal <vgoyal@redhat.com>, Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, mrubin@google.com,
        teravest@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 2:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> You seem pretty unenthusiastic about a).  How do you feel about b)?
>
> IMHO, Using RT group with throttling avoids introducing asymmetry between
> task and group attributes. So I will prefer that approch. Though it means
> more code as we will be introducing RT groups but that might be useful
> in general for something else too. (I am assuming that somebody makes
> use of RT class for cfqq).
>
> The one more down side of trying to use throttling is that one needs to
> come up with absolute limit. So one shall have to know disk capacity
> and if there are no BE tasks running then latency sensitive task will
> be unnecessarily throttled (until and unless some management software
> can monitor it and change limit dynamically).
>
> So if you are worried about setting the absolute limit part, then I guess
> I am fine with option a). But if you think that setting absolute limit
> is not a problem, then option b) is preferred.

I prefer option a) - so much so that even with the older CFQ group
implementation we did work to merge the RT and BE service trees to
achieve that behavior.  But I see that using blkio.class is a poor
choice of interface name.  I will rename the interface and resubmit
the patch series (also with Gui's suggestion to keep the "_device"
suffix for consistency).

Also, we'll soon be working to adopt the hierarchy series, and we'll
likely revisit using an RT service tree there.  It's difficult to
justify introducing RT service tree before those patches arrive.

Thanks,
Chad
