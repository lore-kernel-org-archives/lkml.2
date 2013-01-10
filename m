Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab3AJKCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:02:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab3AJKCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:02:12 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>, gregkh@linuxfoundation.org,
        mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: USB autosuspend vs. URB submission
Date: Thu, 10 Jan 2013 11:02:11 +0100
Message-ID: <5203913.6Ij3EG26lC@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CACVXFVNUJ8i5hOX8oqcBn1rO=KmHQU3WMBVBh9HF=BfJw1QcPw@mail.gmail.com>
References: <20130107204220.GB12363@hansolo.jdub.homelinux.org> <2664900.viczl5BYBS@avalon> <CACVXFVNUJ8i5hOX8oqcBn1rO=KmHQU3WMBVBh9HF=BfJw1QcPw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2013 13:13:58 Ming Lei wrote:
> IMO, there is a minor fault in the error handling path of
> uvc_status_start() inside uvc_v4l2_open(), and the 'users' count
> should have been decreased before usb_autopm_put_interface().
> In theory, the warning can be triggered when the device is
> opened just between usb_autopm_put_interface() and
> atomic_dec(&stream->dev->users), but I don't think it is
> the cause of the report.

Hi,

the analysis is sound. Good catch. As the fix is trivial, I am making
a quick patch.

	Regards
		Oliver

