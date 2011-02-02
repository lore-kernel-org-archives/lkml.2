Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1BBUlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:41:05 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55811 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab1BBUlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:41:04 -0500
Message-ID: <4D49C172.3040600@cs.wisc.edu>
Date: Wed, 02 Feb 2011 14:41:22 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org,
        Jayamohan Kallickal <jayamohank@serverengines.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 16/32] scsi/be2iscsi,qla2xxx: convert to alloc_workqueue()
References: <1294062595-30097-1-git-send-email-tj@kernel.org> <1294062595-30097-17-git-send-email-tj@kernel.org> <4D489B09.9010906@cs.wisc.edu> <20110202102521.GA24115@htj.dyndns.org>
In-Reply-To: <20110202102521.GA24115@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 04:25 AM, Tejun Heo wrote:
> usually necessary.  The queue of pending works tend to be short and
> consumed pretty fast.
>

What if we want to do something that could take a while, like doing 
recovery of a device/transport (so you have to send resets and 
logouts/logins and wait for the results but they could take a while if 
they timeout), should we be using something other than a workqueue so it 
does not interfere with other users?
