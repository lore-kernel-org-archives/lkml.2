Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765Ab1F1SbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 14:31:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42795 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759489Ab1F1SaT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 14:30:19 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikjrf6kQcobm1hL7DqxK8iJqV5kjw@mail.gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1309244992-2305-3-git-send-email-jim.cromie@gmail.com> <BANLkTikjrf6kQcobm1hL7DqxK8iJqV5kjw@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 28 Jun 2011 12:29:49 -0600
Message-ID: <BANLkTimrY8yJKm_u7nyoo1wFc_YXrXX4sA@mail.gmail.com>
Subject: Re: [PATCH 02/11] dynamic_debug: trim source-path prefix from dynamic_debug/control
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, gnb@fmeh.org, jbaron@redhat.com,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 4:08 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
>>
>> Skip past unchanging absolute source-path prefix to print a path
>> thats relative to kernel source's root-dir.  This makes the file
>> easier to read without a wide screen.  For example:
>>
>> kernel/freezer.c:128 [freezer]cancel_freezing - "  clean up: %s\012"


>
> The above will break the output generated for out-of-tree kernel
> modules that use the dynamic debug facility.
>
> Bart.
>

ack, yes.

I'll add a check to see prefix matches before skipping it.
this will reduce efficiency slightly more, but its not a hot path.

thanks.
