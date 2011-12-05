Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab1LEUt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:49:56 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:39437 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab1LEUtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:49:55 -0500
Message-ID: <4EDD2E5C.1050107@free.fr>
Date: Mon, 05 Dec 2011 21:49:32 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: oleg@redhat.com
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [PATCH 0/1][V3] Handle reboot in a child pid namespace
References: <1323030290-22216-1-git-send-email-daniel.lezcano@free.fr>	<20111204212756.GB16362@khazad-dum.debian.net> <4EDBFD67.1040009@free.fr>
In-Reply-To: <4EDBFD67.1040009@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 12:08 AM, Daniel Lezcano wrote:
> On 12/04/2011 10:27 PM, Henrique de Moraes Holschuh wrote:
>> On Sun, 04 Dec 2011, Daniel Lezcano wrote:
>>>  * V3
>>>    - removed lock and serialization of pid_ns_reboot
>>>  * V2
>>>    - added a lock for the pid namespace to prevent racy call
>>>      to the 'reboot' syscall
>>>    - Moved 'reboot' command assigned in zap_pid_ns_processes
>>>      instead of wait_task_zombie
>>>    - added tasklist lock around force_sig
>>>    - added do_exit in pid_ns_reboot
>>>    - used task_active_pid_ns instead of declaring a new variable in sys_reboot
>>>    - moved code up before POWER_OFF changed to HALT in sys_reboot

Oleg ? Are you fine with this patch ?
