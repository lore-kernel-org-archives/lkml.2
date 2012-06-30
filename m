Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2F3OZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 10:25:36 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55495 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754214Ab2F3OZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 10:25:34 -0400
Date: Sat, 30 Jun 2012 10:25:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Len Brown <lenb@kernel.org>
cc: linux-acpi@vger.kernel.org, <linux-pm@lists.linux-foundation.org>,
        Pavel Vasilyev <pavel@pavlinux.ru>, <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>
Subject: Re: [linux-pm] [PATCH 1/8] ACPI sysfs.c strlen fix
In-Reply-To: <9f132652d94c96476b0b0a8caf0c10e96ab10fa8.1341032550.git.len.brown@intel.com>
Message-ID: <Pine.LNX.4.44L0.1206301023540.29029-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2012, Len Brown wrote:

> From: Pavel Vasilyev <pavel@pavlinux.ru>
> 
> Current code is ignoring the last character of "enable" and "disable"
> in comparisons.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=33732
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  drivers/acpi/sysfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
> index 9f66181..240a244 100644
> --- a/drivers/acpi/sysfs.c
> +++ b/drivers/acpi/sysfs.c
> @@ -173,7 +173,7 @@ static int param_set_trace_state(const char *val, struct kernel_param *kp)
>  {
>  	int result = 0;
>  
> -	if (!strncmp(val, "enable", strlen("enable") - 1)) {
> +	if (!strncmp(val, "enable", strlen("enable"))) {

Ironically, this is the less efficient of two possible fixes.

It would have been better to leave the "- 1" in place and change strlen 
to sizeof.  That's probably what the original author had in mind.

Alan Stern

