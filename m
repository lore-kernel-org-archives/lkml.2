Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212Ab2EVTQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:16:28 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50818 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2EVTQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:16:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <ming.lei@canonical.com>, Greg KH <gregkh@linuxfoundation.org>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@vger.kernel.org>
References: <Pine.LNX.4.44L0.1205221008530.2100-100000@iolanthe.rowland.org>
Date: Tue, 22 May 2012 13:16:10 -0600
In-Reply-To: <Pine.LNX.4.44L0.1205221008530.2100-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Tue, 22 May 2012 10:11:41 -0400 (EDT)")
Message-ID: <87wr4458n9.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/08CuOyJ5ZSE8fublojeqjsoOUrzmmfHU=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Stern <stern@rowland.harvard.edu>
X-Spam-Relay-Country: 
Subject: Re: Race condition between driver_probe_device and =?utf-8?Q?devi?=
 =?utf-8?Q?ce=5Fshutdown=E2=80=8F?=
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Tue, 22 May 2012, Ming Lei wrote:
>
>> On Tue, May 22, 2012 at 2:29 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > On Mon, 21 May 2012, Ming Lei wrote:
>> >> Another candidate fix is to register a reboot notifier in driver core to prevent
>> >> driver from being bound or unbound from start of reboot/shutdown, but looks
>> >> not easy as the way of holding device locks.

You might also be able to look at system_state and simply not do any
hotplug work if the state is neither SYSTEM_BOOTING or SYSTEM_RUNNING.

>> > I'd guess it was done this way so that the shutdown task wouldn't have
>> > to wait for a buggy driver that didn't want to release the device lock
>> > (or that crashed while holding the lock).
>> 
>> Maybe, so I understand you agree on adding the device lock as did
>> in the patch, don't I?
>
> I don't know.  It depends on the intention behind the shutdown 
> callback.  Maybe each driver is supposed to be responsible for doing 
> its own locking.
>
> Do you think that a buggy driver should be able to prevent the system 
> from shutting down?

The original intent of the shutdown callback was to just the hardware
part of the device shutdown and not do muck with kernel data structures
because just the device portion should be more reliable and was all
that is needed.

Given the current minimal usage of the device shutdown callback I'm not
convinced the original reasoning made sense but shrug.  So we might
want to reorg things and merge remove and shutdown.  I missed the start
of this thread so I don't know how ambitious everyone is.

Eric

