Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab1HLQZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:25:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26496 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1HLQZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:25:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=ROWKvSakK224mvYvRA704Ln8Ziva2dBAsJ57z+SVCofWAWfdaswCESsMe2TXzLxde
	gZJvybKSgfxoy2u5w9gdQ==
MIME-Version: 1.0
In-Reply-To: <CANxBZFpjtGyk3CO0ViFJF8em_hBFLq7tErjMJrcq5vC7n9cy4g@mail.gmail.com>
References: <1312817901-5313-1-git-send-email-wangshaoyan.pt@taobao.com>
 <CAErSpo6Fh+zTMiSG+mjkNuA03cCEK7bej9y2oX+HfsScSYGFsw@mail.gmail.com>
 <CANxBZFrzmTDaUrmkGhKAVsZpXScEDxdJeBzcMbBjEW=6ozppGw@mail.gmail.com>
 <20110811232735.u5qoybpr4gg8kckw@webmail.mit.edu> <CANxBZFpjtGyk3CO0ViFJF8em_hBFLq7tErjMJrcq5vC7n9cy4g@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 12 Aug 2011 10:24:50 -0600
Message-ID: <CAErSpo6NgwTt0o0u651ojN_xH=5qqVN1o0POTEeK+eV6Y68p7A@mail.gmail.com>
Subject: Re: [PATCH] pnp: replace deprecated __check_region to request_region
To: Wang Shaoyan <stufever@gmail.com>
Cc: Adam M Belay <abelay@mit.edu>, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 10:03 PM, Wang Shaoyan <stufever@gmail.com> wrote:
> I can understand your worry, but back to beginning, just as the
> subject of the patch: "replace deprecated __check_region to
> request_region", I think this patch is still need, although it can't
> solve the problems both you guys mentioned. Do you agree it?

Your patch is presented as "no functional change," but in fact, the
current code does not leave the region reserved, while with your patch
it does.  This is quite a large change and I think it will break
things.

I would like to see the PNP core reserve resources, but it should be
done for all resources of all device.  Your patch only affects ioports
(I think we should do memory as well), and it only affects the
assignment path (I don't think we do this for every device we
enumerate).  And it effectively adds a region reservation without
adding a corresponding release.

Bjorn
