Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab0JaQOH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 12:14:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50518 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab0JaQOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 12:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XkbFeeY+kkAuXKd+VwmzN9PcXRm8R5QhH7lYRDFTxEsOM/h+ALUcW/fUCi6Oig3G3H
         q4UHM8NrpJZfKZU6tT805LI3M2Y8SlNd1sZw23YUoKm3hJ5nqCnY9AHVMQ7jLi+ifJ68
         ziyDww1RHbjYMHTsbFK9ZnsoDiOhKB+2iQEYA=
MIME-Version: 1.0
In-Reply-To: <1288529170-28890-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1288529170-28890-1-git-send-email-samu.p.onkalo@nokia.com>
Date: Mon, 1 Nov 2010 00:14:04 +0800
Message-ID: <AANLkTikRSF-4o=Jnyg2_Wa4gg7E+s_tM9ZD3g+f7hyWm@mail.gmail.com>
Subject: Re: [RFC PATCH] device-core: sysfs open - close notify
From: Ming Lei <tom.leiming@gmail.com>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: gregkh@suse.de, hmh@hmh.eng.br, alan@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/31 Samu Onkalo <samu.p.onkalo@nokia.com>:
> Device drivers have no idea when somebody in userspace keeps some sysfs entry
> open. The driver just received read or write calls. The driver may want to
> control HW state based on activity so it either have to turn HW on and off
> for each sysfs access or it needs separate enable disable entry which controls
> the HW state. In cases where sysfs is used to pass some events under interrupt
> control (like proximity events from the proximity sensors) it is not enough to
> just keep sysfs entry open in userspace.

Since very few drivers have this kind of requirement, why not take notifier
call chain mechanism to do such thing? eg. register a notifier function
if the driver is interested in such kind of open/close events.

Your patch may cause many unnecessary memory waste because
most of drivers does not need attribute file .open/.close notifier.


thanks,
-- 
Lei Ming
