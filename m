Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab0GHV2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 17:28:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42716 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0GHV2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 17:28:01 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikazGZZ6dDLpGQaRH7j-_M7hzinxmAP0TD84G2n@mail.gmail.com>
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com> 
	<20100708012120.GB11419@auslistsprd01.us.dell.com> <D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com> 
	<AANLkTikazGZZ6dDLpGQaRH7j-_M7hzinxmAP0TD84G2n@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 8 Jul 2010 23:27:44 +0200
Message-ID: <AANLkTilLL-NwIISVg8XmwlWDarzzixiYaVNj8hPnc1kn@mail.gmail.com>
Subject: Re: nic enumeration
To: Andrew Fong <ayf@youtube.com>
Cc: "Loke, Chetan" <Chetan.Loke@netscout.com>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Michael Di Domenico <mdidomenico4@gmail.com>, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 8, 2010 at 22:47, Andrew Fong <ayf@youtube.com> wrote:
> On Thu, Jul 8, 2010 at 1:36 PM, Loke, Chetan <Chetan.Loke@netscout.com> wrote:
>>> -----Original Message-----
>>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>>> owner@vger.kernel.org] On Behalf Of Matt Domsch
>>> Sent: July 07, 2010 9:21 PM
>>>
>>> http://lwn.net/Articles/356900/
>>>
>>> And on a system where you can use udev rules, the
>>> 70-persistent-net.rules file can be used to make them constant, by
>>> using the MAC address to force the names to be what you want.
>>
>> Ok, but can we achieve the renaming w/o a reboot?
>
> You probably can restart the udev subsystem.

No, udev has not really a concept of being restarted, it will not do
anything. You can only synthesize events, so it looks like the device
is just plugged in. For that, you need to make sure the interface is
not busy, otherwise renaming will fail in interesting ways, especially
if names need to be swapped between several devices.

Live renaming of interfaces is something you really need to know what
you are doing, especially on remote machines.

Kay
