Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1ITKzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 06:55:19 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61252 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab1ITKzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 06:55:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd9bmw12By6StTL_MRzAGsgG9BOfcvs=TA-nRu_uxMzOcw@mail.gmail.com>
References: <1316359301-2263-1-git-send-email-linkinjeon@gmail.com>
	<4E78433F.2050900@stericsson.com>
	<CA+Wuu-vAx8PkvPgy5mR5Bcg6e+q6Z3XOZtTGwNZgCW4HCrX5KA@mail.gmail.com>
	<CAKYAXd9bmw12By6StTL_MRzAGsgG9BOfcvs=TA-nRu_uxMzOcw@mail.gmail.com>
Date: Tue, 20 Sep 2011 16:25:16 +0530
Message-ID: <CA+Wuu-sK6B_k0+sG_p4JRuHOwO_HVCpNksg-9_TdpzXRS7y0xA@mail.gmail.com>
Subject: Re: [PATCH] mmc : Use wait_for_completion_timeout() instead of
 wait_for_completion in case of write.
From: Murali Krishna Palnati <palnati.muralikrishna@gmail.com>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: Ulf Hansson <ulf.hansson@stericsson.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 4:05 PM, NamJae Jeon <linkinjeon@gmail.com> wrote:
> yes, I knew. But if card keep holding busy line(data 0) in the middle
> of DMA operation(multi blocks write),  host driver layer can not know
> card status in this situation.

The host driver shall start a software timer and indpendently needs to
watch out for the expiry of the timeout. If the host doesn't hear back
from the
controller/DMA engine even after waiting for the specified timeout,
then the timer handler that gets invoked can then do the necessary
cleanup and
inform the MMC core layer that the request failed. Does this sound feasible?
