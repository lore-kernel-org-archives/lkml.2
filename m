Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab1BDC1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 21:27:23 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41668 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab1BDC1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 21:27:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q0/DR91YUlGGv4o0PdObuSGVzqOQPtMF97IcFCvjs9qwfGa8FpLs16JHEPuEBjm3xk
         pN1dileSdSBk8Is6ZdNxfBtwPPNYaXf2idcijbBPXg8BHlEGBlg2nvCorqo1BGAC0Unn
         A+WLc/UbkVwhJG97iIkVGWA1jh7fCU7Wb6WO4=
Date: Fri, 4 Feb 2011 10:24:27 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Subject: Re: Query about kdump_msg hook into crash_kexec()
Message-ID: <20110204022427.GA13902@cr0.redhat.com>
References: <20110131225939.GH11974@redhat.com>
 <20110203094715.939C.A69D9226@jp.fujitsu.com>
 <20110203020528.GA21603@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C147F4346@USINDEVS01.corp.hds.com>
 <m14o8klt3w.fsf@fess.ebiederm.org>
 <5C4C569E8A4B9B42A84A977CF070A35B2C147F43B7@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C147F43B7@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 05:08:01PM -0500, Seiji Aguchi wrote:
>Hi Eric,
>
>Thank you for your prompt reply.
>
>I would like to consider "Needs in enterprise area" and "Implementation of kmsg_dump()" separately.
>
>(1) Needs in enterprise area
>  In case of kdump failure, we would like to store kernel buffer to NVRAM/flush memory
>  for detecting root cause of kernel crash.
>
>(2) Implementation of kmsg_dump 
>  You suggest to review/test cording of kmsg_dump() more.
>
>What do you think about (1)?
>Is it acceptable for you?
>

For "in case of kdump fails", we can move
KMSG_DUMP_OOPS/KMSG_DUMP_PANIC before calling crash_kexec(),
so you can capture the log before kdump happens.

