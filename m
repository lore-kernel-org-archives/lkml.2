Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab2G3TMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:12:39 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:22521 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753922Ab2G3TMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:12:37 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I542M1432Izz1202hzzz2fh2a8h683h839h93fhd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: RE: [PATCH 13/17] Tools: hv: Implement the KVP verb -
 KVP_OP_SET_IP_INFO
Thread-Topic: [PATCH 13/17] Tools: hv: Implement the KVP verb -
 KVP_OP_SET_IP_INFO
Thread-Index: AQHNabffApGkoXQ/oEyNNUVPYtB2bpdCH2aAgAAVt1A=
Date: Mon, 30 Jul 2012 19:12:22 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236AA80F@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-13-git-send-email-kys@microsoft.com>
 <20120730173323.GA533@aepfle.de>
In-Reply-To: <20120730173323.GA533@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.56.91]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT001.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6UJChX8006376



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Monday, July 30, 2012 1:33 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; netdev@vger.kernel.org;
> ben@decadent.org.uk
> Subject: Re: [PATCH 13/17] Tools: hv: Implement the KVP verb -
> KVP_OP_SET_IP_INFO
> 
> On Tue, Jul 24, K. Y. Srinivasan wrote:
> 
> > +static char *kvp_get_if_name(char *guid)
> > +{
> > +	DIR *dir;
> > +	struct dirent *entry;
> > +	FILE    *file;
> > +	char    *p, *q, *x;
> > +	char    *if_name = NULL;
> > +	char    buf[256];
> > +	char *kvp_net_dir = "/sys/class/net/";
> > +	char dev_id[100];
> 
> Perhaps this can be written as char dev_id[100] = "short string";?

Why?

> 
> > +
> > +	dir = opendir(kvp_net_dir);
> > +	if (dir == NULL)
> > +		return NULL;
> > +
> > +	memset(dev_id, 0, sizeof(dev_id));
> > +	strcat(dev_id, kvp_net_dir);
> > +	q = dev_id + strlen(kvp_net_dir);
> > +
> > +	while ((entry = readdir(dir)) != NULL) {
> > +		/*
> > +		 * Set the state for the next pass.
> > +		 */
> > +		*q = '\0';
> > +		strcat(dev_id, entry->d_name);
> > +		strcat(dev_id, "/device/device_id");
> 
> Maybe this (and other) strcat should be changed to snprintf?

Already done.

> 


> > +
> > +		file = fopen(dev_id, "r");
> > +		if (file == NULL)
> > +			continue;
> > +
> > +		p = fgets(buf, sizeof(buf), file);
> > +		if (p) {
> > +			x = strchr(p, '\n');
> > +			if (x)
> > +				*x = '\0';
> > +
> > +			if (!strcmp(p, guid)) {
> > +				/*
> > +				 * Found the guid match; return the interface
> > +				 * name. The caller will free the memory.
> > +				 */
> > +				if_name = strdup(entry->d_name);
> > +				break;
> 
> This will leave 'file' open.
> I have seen it in some other place as well.

I will audit all instances and fix it.

> 
> > +			}
> > +		}
> > +		fclose(file);
> > +	}
> > +
> > +	closedir(dir);
> > +	return if_name;
> > +}
> > +
> > +/*
> > + * Retrieve the MAC address given the interface name.
> > + */
> > +
> > +static char *kvp_if_name_to_mac(char *if_name)
> > +{
> > +	FILE    *file;
> > +	char    *p, *x;
> > +	char    buf[256];
> > +	char addr_file[100];
> > +	int i;
> > +	char *mac_addr = NULL;
> > +
> > +	memset(addr_file, 0, sizeof(addr_file));
> > +	strcat(addr_file, "/sys/class/net/");
> > +	strcat(addr_file, if_name);
> > +	strcat(addr_file, "/address");
> 
> snprintf?

Already fixed.

> 
> > +
> > +	file = fopen(addr_file, "r");
> > +	if (file == NULL)
> > +		return NULL;
> > +
> > +	p = fgets(buf, sizeof(buf), file);
> > +	if (p) {
> > +		x = strchr(p, '\n');
> > +		if (x)
> > +			*x = '\0';
> > +		for (i = 0; i < strlen(p); i++)
> > +			p[i] = toupper(p[i]);
> > +		mac_addr = strdup(p);
> > +	}
> > +
> > +	fclose(file);
> > +	return mac_addr;
> > +}
> > +
> > +
> >  static void kvp_process_ipconfig_file(char *cmd,
> >  					char *config_buf, int len,
> >  					int element_size, int offset)
> > @@ -800,6 +910,314 @@ getaddr_done:
> >  }
> >
> >
> > +static int expand_ipv6(char *addr, int type)
> > +{
> > +	int ret;
> > +	struct in6_addr v6_addr;
> > +
> > +	ret = inet_pton(AF_INET6, addr, &v6_addr);
> > +
> > +	if (ret != 1) {
> > +		if (type == NETMASK)
> > +			return 1;
> > +		return 0;
> > +	}
> > +
> > +	sprintf(addr, "%02x%02x:%02x%02x:%02x%02x:%02x%02x:%02x%02x:"
> > +		"%02x%02x:%02x%02x:%02x%02x",
> > +		(int)v6_addr.s6_addr[0], (int)v6_addr.s6_addr[1],
> > +		(int)v6_addr.s6_addr[2], (int)v6_addr.s6_addr[3],
> > +		(int)v6_addr.s6_addr[4], (int)v6_addr.s6_addr[5],
> > +		(int)v6_addr.s6_addr[6], (int)v6_addr.s6_addr[7],
> > +		(int)v6_addr.s6_addr[8], (int)v6_addr.s6_addr[9],
> > +		(int)v6_addr.s6_addr[10], (int)v6_addr.s6_addr[11],
> > +		(int)v6_addr.s6_addr[12], (int)v6_addr.s6_addr[13],
> > +		(int)v6_addr.s6_addr[14], (int)v6_addr.s6_addr[15]);
> > +
> > +	return 1;
> > +
> > +}
> > +
> > +static int is_ipv4(char *addr)
> > +{
> > +	int ret;
> > +	struct in_addr ipv4_addr;
> > +
> > +	ret = inet_pton(AF_INET, addr, &ipv4_addr);
> > +
> > +	if (ret == 1)
> > +		return 1;
> > +	return 0;
> > +}
> > +
> > +static int parse_ip_val_buffer(char *in_buf, int *offset,
> > +				char *out_buf, int out_len)
> > +{
> > +	char *x;
> > +	char *start;
> > +
> > +	/*
> > +	 * in_buf has sequence of characters that are seperated by
> > +	 * the character ';'. The last sequence does not have the
> > +	 * terminating ";" character.
> > +	 */
> > +	start = in_buf + *offset;
> > +
> > +	x = strchr(start, ';');
> > +	if (x)
> > +		*x = 0;
> > +	else
> > +		x = start + strlen(start);
> > +
> > +	if (strlen(start) != 0) {
> > +		int i = 0;
> > +		/*
> > +		 * Get rid of leading spaces.
> > +		 */
> > +		while (start[i] == ' ')
> > +			i++;
> > +
> > +		if ((x - start) <= out_len) {
> > +			strcpy(out_buf, (start + i));
> > +			*offset += (x - start) + 1;
> > +			return 1;
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int kvp_write_file(FILE *f, char *s1, char *s2, char *s3)
> > +{
> > +	char str[256];
> > +	int error;
> > +
> > +	memset(str, 0, sizeof(str));
> > +	strcat(str, s1);
> > +	if (s2 != NULL)
> > +		strcat(str, s2);
> > +	strcat(str, "=");
> > +	strcat(str, s3);
> > +	strcat(str, "\n");
> > +
> > +	error = fputs(str, f);
> > +	if (error == EOF)
> > +		return HV_E_FAIL;
> > +
> > +	return 0;
> > +}
> > +
> > +
> > +static int process_ip_string(FILE *f, char *ip_string, int type)
> > +{
> > +	int error = 0;
> > +	char addr[INET6_ADDRSTRLEN];
> > +	int i = 0;
> > +	int j = 0;
> > +	char str[256];
> > +	char sub_str[10];
> > +	int offset = 0;
> > +
> > +	memset(addr, 0, sizeof(addr));
> > +
> > +	while (parse_ip_val_buffer(ip_string, &offset, addr,
> > +					(MAX_IP_ADDR_SIZE * 2))) {
> > +		memset(sub_str, 0, sizeof(sub_str));
> > +		memset(str, 0, sizeof(str));
> > +
> > +		if (is_ipv4(addr)) {
> > +			switch (type) {
> > +			case IPADDR:
> > +				strcat(str, "IPADDR");
> > +				break;
> > +			case NETMASK:
> > +				strcat(str, "NETMASK");
> > +				break;
> > +			case GATEWAY:
> > +				strcat(str, "GATEWAY");
> > +				break;
> > +			case DNS:
> > +				strcat(str, "DNS");
> > +				break;
> > +			}
> > +			if (i != 0) {
> > +				if (type != DNS)
> > +					sprintf(sub_str, "_%d", i++);
> > +				else
> > +					sprintf(sub_str, "%d", ++i);
> > +			} else if (type == DNS) {
> > +				sprintf(sub_str, "%d", ++i);
> > +			}
> > +
> > +
> > +		} else if (expand_ipv6(addr, type)) {
> > +			switch (type) {
> > +			case IPADDR:
> > +				strcat(str, "IPV6ADDR");
> > +				break;
> > +			case NETMASK:
> > +				strcat(str, "IPV6NETMASK");
> > +				break;
> > +			case GATEWAY:
> > +				strcat(str, "IPV6_DEFAULTGW");
> > +				break;
> > +			case DNS:
> > +				strcat(str, "DNS");
> > +				break;
> > +			}
> > +			if ((j != 0) || (type == DNS)) {
> > +				if (type != DNS)
> > +					sprintf(sub_str, "_%d", j++);
> > +				else
> > +					sprintf(sub_str, "%d", ++i);
> > +			} else if (type == DNS) {
> > +				sprintf(sub_str, "%d", ++i);
> > +			}
> > +		} else {
> > +			return  HV_INVALIDARG;
> > +		}
> > +
> > +		error = kvp_write_file(f, str, sub_str, addr);
> > +		if (error)
> > +			return error;
> > +		memset(addr, 0, sizeof(addr));
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value
> *new_val)
> > +{
> > +	int error = 0;
> > +	char if_file[50];
> > +	FILE *file;
> > +	char cmd[512];
> > +	char *mac_addr;
> > +
> > +	/*
> > +	 * Set the configuration for the specified interface with
> > +	 * the information provided. Since there is no standard
> > +	 * way to configure an interface, we will have an external
> > +	 * script that does the job of configuring the interface and
> > +	 * flushing the configuration.
> > +	 *
> > +	 * The parameters passed to this external script are:
> > +	 * 1. A configuration file that has the specified configuration.
> > +	 *
> > +	 * We will embed the name of the interface in the configuration
> > +	 * file: ifcfg-ethx (where ethx is the interface name).
> > +	 *
> > +	 * Here is the format of the ip configuration file:
> > +	 *
> > +	 * HWADDR=macaddr
> > +	 * BOOTPROTO=dhcp (dhcp enabled for the interface)
> > +	 * NM_CONTROLLED=no (this interface will not be controlled by NM)
> > +	 * PEERDNS=yes
> > +	 * IPADDR_x=ipaddr
> > +	 * NETMASK_x=netmask
> > +	 * GATEWAY_x=gateway
> > +	 * DNSx=dns
> > +	 *
> > +	 * IPV6 addresses will be tagged as IPV6ADDR, IPV6 gateway will be
> > +	 * tagged as IPV6_DEFAULTGW and IPV6 NETMASK will be tagged as
> > +	 * IPV6NETMASK.
> > +	 */
> > +
> > +	memset(if_file, 0, sizeof(if_file));
> > +	strcat(if_file, "/var/opt/hyperv/ifcfg-");
> > +	strcat(if_file, if_name);
> > +
> > +	file = fopen(if_file, "w");
> > +
> > +	if (file == NULL) {
> > +		syslog(LOG_ERR, "Failed to open config file");
> > +		return HV_E_FAIL;
> > +	}
> > +
> > +	/*
> > +	 * First write out the MAC address.
> > +	 */
> > +
> > +	mac_addr = kvp_if_name_to_mac(if_name);
> > +	if (mac_addr == NULL) {
> > +		error = HV_E_FAIL;
> > +		goto setval_error;
> > +	}
> > +
> > +	error = kvp_write_file(file, "HWADDR", NULL, mac_addr);
> > +	if (error)
> > +		goto setval_error;
> > +
> > +	error = kvp_write_file(file, "ONBOOT", NULL, "yes");
> > +	if (error)
> > +		goto setval_error;
> > +
> > +	error = kvp_write_file(file, "IPV6INIT", NULL, "yes");
> > +	if (error)
> > +		goto setval_error;
> > +
> > +	error = kvp_write_file(file, "NM_CONTROLLED", NULL, "no");
> > +	if (error)
> > +		goto setval_error;
> > +
> > +	error = kvp_write_file(file, "PEERDNS", NULL, "yes");
> > +	if (error)
> > +		goto setval_error;
> > +
> > +	if (new_val->dhcp_enabled) {
> > +		error = kvp_write_file(file, "BOOTPROTO", NULL, "dhcp");
> > +		if (error)
> > +			goto setval_error;
> > +
> > +		/*
> > +		 * We are done!.
> > +		 */
> > +		goto setval_done;
> > +	}
> > +
> > +	/*
> > +	 * Write the configuration for ipaddress, netmask, gateway and
> > +	 * name servers.
> > +	 */
> > +
> > +	error = process_ip_string(file, (char *)new_val->ip_addr, IPADDR);
> > +	if (error)
> > +		goto setval_error;
> > +
> > +	error = process_ip_string(file, (char *)new_val->sub_net, NETMASK);
> > +	if (error)
> > +		goto setval_error;
> > +
> > +	error = process_ip_string(file, (char *)new_val->gate_way, GATEWAY);
> > +	if (error)
> > +		goto setval_error;
> > +
> > +	error = process_ip_string(file, (char *)new_val->dns_addr, DNS);
> > +	if (error)
> > +		goto setval_error;
> > +
> > +setval_done:
> > +	free(mac_addr);
> > +	fclose(file);
> > +
> > +	/*
> > +	 * Now that we have populated the configuration file,
> > +	 * invoke the external script to do its magic.
> > +	 */
> > +
> > +	memset(cmd, 0, sizeof(cmd));
> > +	strcat(cmd, "/sbin/hv_set_ifconfig ");
> > +	strcat(cmd, if_file);
> 
> The new patch should use "%s %s", not "%s%s" as format string.
> 
> 
> 

Thanks Olaf,

K. Y
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
